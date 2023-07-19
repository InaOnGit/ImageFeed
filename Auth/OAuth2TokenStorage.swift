//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Ina on 07/06/2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    static let shared = OAuth2TokenStorage()
    
    private let keychainWrapper = KeychainWrapper.standard
    
    var token: String? {
        get {
            keychainWrapper.string(forKey: Constants.bearerToken)
        }
        set {
            guard let newValue = newValue else { return }
            keychainWrapper.set(newValue, forKey: Constants.bearerToken)
        }
    }
    
    func clean() {
        keychainWrapper.removeAllKeys()
    }
}
