//
//  LoginViewModel.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-06-01.
//

import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    
    @Published var username = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var invalid = false
    
    private var authentication = Authentication()
    
    init(authentication: Authentication = Authentication.shared) {
        self.authentication = authentication
    }
    
   func login(completion: @escaping (Bool) -> Void) {
        
        authentication.authenticate(username: username, password: password) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    self?.authentication.isAuthenticated = true
                    completion(true) // login successful
                case .failure(let error):
                    self?.authentication.isAuthenticated = false
                    self?.errorMessage = error.localizedDescription
                    completion(false) // login failed
                }
            }
        }
    }
}
