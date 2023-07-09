//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Ina on 08/07/2023.
//
import Foundation
import UIKit

final class ImagesListService {
    private (set) var photos: [Photo] = []
    
    private var lastLoadedPage: Int?
    private var currentTask: URLSessionTask?
    private var isFetching = false
    private let perPage = "10"
    
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    func fetchPhotoNextPage() {
        assert(Thread.isMainThread)
        guard !isFetching else { return }
        currentTask?.cancel()
        
        guard let request = fetchImagesRequest("") else {
            assertionFailure("Invalid Request")
            return
        }
        
        let nextPage = lastLoadedPage == nil ? 1 : (lastLoadedPage! + 1)
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (response: Result<[Photo], Error>) in
            guard let self = self else { return }
            
            switch response {
            case .success(let newPhotos):
                DispatchQueue.main.async {
                    self.photos.append(contentsOf: newPhotos)
                    self.isFetching = false
                    
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: nil)
                }
            case .failure(let error):
                print("Fail to fetch photos \(error)")
                self.isFetching = false
            }
        }
        self.currentTask = task
        task.resume()
    }
    
    private func fetchImagesRequest(_ token: String) -> URLRequest? {
        return URLRequestBuilder.makeHTTPRequest(
            path: "/photos?page=\(lastLoadedPage ?? 1)&&per_page=\(perPage)",
            httpMethod: "GET",
            baseURL: Constants.defaultApiBaseURL
        )
    }
}
