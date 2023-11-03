//
//  Authentication.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-05-29.
//

import Foundation
import SwiftUI

class Authentication: ObservableObject {
    
    @AppStorage("AUTH_KEY") var isAuthenticated = false {
        willSet { objectWillChange.send() }
    }
    
    static let shared = Authentication()
    
    private let keychainWrapper = KeychainWrapper()
    private let baseURL: URL
    
    init(baseURL: URL = URL(string: WeavyAPIConfig.appServerBaseURL)!) {
        self.baseURL = baseURL
    }
    
    func authenticate(username: String, password: String, completion: @escaping (Result<TokenResponse, Error>) -> Void) {
        
        let path = WeavyAPIConfig.appServerTokenEndpoint
        
        let url = baseURL.appendingPathComponent(path)
        
        let parameters = ["username": username, "password": password]
        let jsonData = try? JSONEncoder().encode(parameters)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response"])))
                return
            }
            
            let statusCode = httpResponse.statusCode
            
            if !(200..<300).contains(statusCode) {
                completion(.failure(NSError(domain: "", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Server error"])))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Empty response data"])))
                return
            }
            
            if let tokenResponse = try? JSONDecoder().decode(TokenResponse.self, from: data) {
                self.keychainWrapper.storeAccessToken(token: tokenResponse.accessToken, expiresIn: tokenResponse.expiresIn)
                completion(.success(tokenResponse)) // added this to store access token. it wasn't called earlier, so keychain just used old one.
            } else {
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid response data"])))
            }
            
        }.resume()
    }
    
    func logOut() {
        print("logout pressed, Authentication")
        keychainWrapper.removeAccessToken()
        isAuthenticated = false
    }
}

struct TokenResponse: Decodable {
    let accessToken: String
    let expiresIn: Int
}
