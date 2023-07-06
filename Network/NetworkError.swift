//
//  NetworkError.swift
//  ImageFeed
//
//  Created by Ina on 30/06/2023.
//

import Foundation

enum NetworkError: Error {
    case decodingError(Error)
    case httpStatusCode(Int)
    case urlRequestError(Error)
    case urlSessionError
    case invalidRequest
}
