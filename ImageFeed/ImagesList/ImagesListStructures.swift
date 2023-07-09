//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Ina on 08/07/2023.
//

import Foundation

struct Photo: Decodable, Equatable {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    let isLiked: Bool
}

struct PhotoResult: Codable {
    let id: String
    let createdAt: String?
    let updatedAt: String?
    let width: Int
    let height: Int
    let color: String
    let description: String
    let urls: UrlsResult
    
    private enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width
        case height
        case color
        case description
        case urls
    }
}
    
    struct UrlsResult: Codable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }

extension Photo {
    init(photoResult: PhotoResult) {
        id = photoResult.id
        size = CGSize(width: photoResult.width, height: photoResult.height)
        createdAt = ISO8601DateFormatter().date(from: photoResult.createdAt ?? "")
        welcomeDescription = photoResult.description
        thumbImageURL = photoResult.urls.thumb
        largeImageURL = photoResult.urls.regular
        isLiked = false
    }
}
