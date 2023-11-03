//
//  KeychainWrapper.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-06-01.
//

import Foundation
import KeychainAccess


//Defining constants

struct KeychainKeys {
    static let accessToken = "ACCESS_TOKEN"
    static let accessTokenExpiration = "ACCESS_TOKEN_EXPIRATION"
}


class KeychainWrapper {
    
    private let keychain = Keychain(service: "")
    
    func storeAccessToken(token: String, expiresIn: Int) {
        let expirationDate = Date().addingTimeInterval(TimeInterval(expiresIn))
        keychain[KeychainKeys.accessToken] = token
        
        keychain[KeychainKeys.accessTokenExpiration] = "\(expirationDate.timeIntervalSince1970)"
        
        
    }
    
    func retrieveAccessToken() -> String? {
        return keychain[KeychainKeys.accessToken]
    }
    
   /* func retrieveTokenExpirationDate() -> Date? {
        if let expirationString = keychain[KeychainKeys.accessTokenExpiration],
           let expirationTimeInterval = TimeInterval(expirationString) {
            return Date(timeIntervalSince1970: expirationTimeInterval)
        }
        return nil
    }*/
    
    func removeAccessToken() {
        keychain[KeychainKeys.accessToken] = nil
    }
    
   /* func removeTokenExpirationDate() {
        keychain[KeychainKeys.accessTokenExpiration] = nil
    }*/
}
