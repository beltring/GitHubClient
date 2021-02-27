//
//  AuthorizeData.swift
//  GithubClient
//
//  Created by Pavel Boltromyuk on 2/27/21.
//

import Foundation
import KeychainSwift

class AuthorizeData {
    static let shared = AuthorizeData()
    private let keychain = KeychainSwift()
    
    private init() {}
    
    var accessToken: String? {
        get {
            return keychain.get(KeychainKeys.accessToken.rawValue)
        }
        set {
            if let token = newValue {
                keychain.set(token, forKey: KeychainKeys.accessToken.rawValue)
            }
        }
    }
}
