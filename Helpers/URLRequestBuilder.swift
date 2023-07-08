//
//  URLRequest+Extention.swift
//  ImageFeed
//
//  Created by Ina on 25/06/2023.
//

import Foundation

final class URLRequestBuilder {
    static let shared = URLRequestBuilder()
    static let storage: OAuth2TokenStorage = .shared// создаем отдельную зависимость для хранения токена
    
    private init() {} //добавлен по совету Г
    
    static func makeHTTPRequest(path: String, httpMethod: String, baseURL: String) -> URLRequest? {
        guard
            let url = URL(string: baseURL),
            let baseUrl = URL(string: path, relativeTo: url)
        else { return nil }
        
        var request = URLRequest(url: baseUrl)
        request.httpMethod = httpMethod
        
        if let token = storage.token { //достает токен, полученный при запросе в OAuthService
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization") // модифицируем request с помощью функции setValue
        }
        return request
    }
}
