//
//  Constants.swift
//  ImageFeed
//
//  Created by Ina on 26/05/2023.
//

import Foundation

enum Constants {
    //MARK: Unsplash API constants
    static let accessKey = "OkWpcNDPpvRBuBrsqrlK1X8ilo7g0aNVwfJAnkJ3EsU"
    static let secretKey = "AZwmKahc6yDjoUN8_Ym8GYcEJojYU1b4sqmfqQvY48I"
    static let redirectedURI = "urn:ietf:wg:oauth:2.0:oob"
    static let accessScope = "public+read_user+write_likes"
    
    //MARK: Unsplash API base paths
    static let defaultApiBaseURL = "https://api.unsplash.com"
    static let baseURL = "https://unsplash.com"
    static let unsplashAuthorizeURL = "https://unsplash.com/oauth/authorize"
    
    //MARK: storage constants
    static let bearerToken = "https://unsplash.com/oauth/token"  
}
