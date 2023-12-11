//
//  OAuth2TokenResponseBody.swift
//  ImageFeed
//
//  Created by Ina on 25/06/2023.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
    
    
}
