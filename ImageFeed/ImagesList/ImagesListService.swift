//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Ina on 08/07/2023.
//
import Foundation
import UIKit

final class ImagesListService {
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private (set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    private var currentTask: URLSessionTask?
    private let perPage = "10"
    private let dateFormat = ISO8601DateFormatter()
    private let builder: URLRequestBuilder
    
    init(builder: URLRequestBuilder = .shared) {
        self.builder = builder
    }
    
    func fetchPhotoNextPage() {
        assert(Thread.isMainThread)
        if currentTask != nil {
            currentTask?.cancel()
        }
        let nextPage = lastLoadedPage == nil ? 1 : (lastLoadedPage! + 1)
        guard let request = fetchImagesRequest(page: nextPage) else {
            assertionFailure("Invalid Request")
            return
        }
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (response: Result<[PhotoResult], Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch response {
                case .success(let newPhotoResult):
                    if self.lastLoadedPage == nil {
                        self.lastLoadedPage = 1
                    } else {
                        self.lastLoadedPage! += 1
                    }
                    let newPhoto = newPhotoResult.map { Photo(photoResult: $0, dateFormat: self.dateFormat) }
                    self.photos.append(contentsOf: newPhoto) // добавление фото в конец массивa
                    
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                    
                case .failure(let error):
                    print("Fail to fetch photos \(error)")
                }
            }
        }
        self.currentTask = task
        task.resume()
    }
    
    func fetchImagesRequest(page: Int) -> URLRequest? {
        return builder.makeHTTPRequest(
            path: "/photos" + "?page=\(page)&per_page=10",
            httpMethod: "GET",
            baseURL: Constants.defaultApiBaseURL
        )
    }
    
    func changeLike(photoId: String, isLike: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        if currentTask != nil {
            currentTask?.cancel()
        }
        
        guard let request = makeLikeRequest(isLike: isLike, photoId: photoId) else {
            assertionFailure("Like's empty")
            return
        }
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (response: Result<LikedPhoto, Error>) in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch response {
                case .success:
                    if let index = self.photos.firstIndex(where: { $0.id == photoId }) {
                        let photo = self.photos[index]
                        let newPhotoResult = PhotoResult(
                            id: photo.id,
                            createdAt: photo.createdAt?.description,
                            width: Int(photo.size.width),
                            height: Int(photo.size.height),
                            description: photo.welcomeDescription ?? "",
                            urls: UrlsResult(full: photo.largeImageURL, thumb: photo.thumbImageURL),
                            likedByUser: !photo.isLiked
                        )
                        let newPhoto = Photo(
                            photoResult: newPhotoResult,
                            dateFormat: self.dateFormat)
                        self.photos = self.photos.withReplaced(itemAt: index, newValue: newPhoto)
                        completion(.success(()))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
                self.currentTask = nil
            }
        }
        self.currentTask = task
        task.resume()
    }
    
    struct LikedPhoto: Decodable {
        let photo: PhotoResult
    }
    
    private func makeLikeRequest(isLike: Bool, photoId: String) -> URLRequest? {
        return builder.makeHTTPRequest(
            path: "photos/\(photoId)/like",
            httpMethod: isLike ? "POST" : "DELETE",
            baseURL: Constants.defaultApiBaseURL
        )
    }
    
    func resetPhotos() {
        photos.removeAll()
        lastLoadedPage = nil
        NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
    }
}



extension Array {
    func withReplaced(itemAt index: Int, newValue: Element) -> Array {
        var photos = self
        photos[index] = newValue
        return photos
    }
}
