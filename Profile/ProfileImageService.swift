//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Ina on 26/06/2023.
//
import UIKit

final class ProfileImageService {
    static let shared = ProfileImageService()
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    private var currentTask: URLSessionTask?
    
    private (set) var avatarURL: String?
    
    private let builder: URLRequestBuilder
    
    init(builder: URLRequestBuilder = .shared) {
        self.builder = builder
    }
    
    func fetchProfileImageURL(userName: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        
        guard let request = makeRequest(userName: userName) else { return }
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (result: Result<ProfileResult, Error>) in
            guard let self =  self else { return }
            switch result {
            case .success(let profilePhoto):
                guard let mediumPhoto = profilePhoto.profileImage?.medium else { return }
                self.avatarURL = mediumPhoto
                completion(.success(mediumPhoto))
                
                NotificationCenter.default.post(
                    name: ProfileImageService.didChangeNotification,
                    object: self,
                    userInfo: [Notification.userInfoImageURLKey: mediumPhoto]
                )
            case .failure(let error):
                completion(.failure(error))
            }
            self.currentTask = nil
        }
        self.currentTask = task
        task.resume()
    }
    
    private func makeRequest(userName: String) -> URLRequest? {
        builder.makeHTTPRequest(
            path: "/users/\(userName)",
            httpMethod: "GET",
            baseURL: Constants.defaultApiBaseURL
        )
    }
}

extension Notification {
    static let userInfoImageURLKey: String = "URL"
    var userInfoImageURL: String? {
        userInfo?[Notification.userInfoImageURLKey] as? String
    }
}
