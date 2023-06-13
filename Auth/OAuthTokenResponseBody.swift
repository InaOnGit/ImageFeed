//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Ina on 08/06/2023.
//

import Foundation

private struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
    
    let url = URL(string: "https://unsplash.com/oauth/token")!
}
