//
//  ErrorHandler.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-09-22.
//

import Foundation

class ErrorHandler: ObservableObject {
    
    @Published var received401: Bool = false
    @Published var isIntentionalLogout = false
    

    
    func resetErrors() {
        received401 = false
    }
}
