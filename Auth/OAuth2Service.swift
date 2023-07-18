//
//  OAuth2service.swift
//  ImageFeed
//
//  Created by Ina on 04/06/2023.
//

import Foundation

final class OAuth2Service {
    static let shared = OAuth2Service()
    
    private let urlSession: URLSession
    private let storage: OAuth2TokenStorage
    private let builder: URLRequestBuilder
    
    private var task: URLSessionTask?
    private var lastCode: String?
    private var currentTask: URLSessionTask?
    
    init(
        urlSession: URLSession = .shared,
        storage: OAuth2TokenStorage = .shared,
        builder: URLRequestBuilder = .shared
    ) {
        self.urlSession = urlSession
        self.storage = storage
        self.builder = builder
    }
    
    var isAuthenticated: Bool {
        storage.token != nil
    }
    
    func fetchOAuthToken(_ code: String, completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastCode == code { return }
        task?.cancel()
        lastCode = code
        
        guard let request = authTokenRequest(code: code) else {
            assertionFailure("Invalid request")
            completion(.failure(NetworkError.invalidRequest))
            return
        }
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { [weak self] (response: Result<OAuthTokenResponseBody, Error>) in
            DispatchQueue.main.async {
                guard let self else { return }
                switch response {
                case .success(let body):
                    let authToken = body.accessToken
                    self.storage.token = authToken
                    completion(.success(authToken))
                    self.task = nil
                case .failure(let error):
                    completion(.failure(error))
                    self.lastCode = nil
                }
            }
        }
        self.currentTask = task
        task.resume()
    }
}

extension OAuth2Service {
    private func authTokenRequest(code: String) -> URLRequest? {
        builder.makeHTTPRequest(
            path: Constants.bearerToken
            + "?client_id=\(Constants.accessKey)"
            + "&&client_secret=\(Constants.secretKey)"
            + "&&redirect_uri=\(Constants.redirectedURI)"
            + "&&code=\(code)"
            + "&&grant_type=authorization_code",
            httpMethod: "POST",
            baseURL: Constants.baseURL
        )
    }
}
