//
//  Handle401ErrorModifier.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-09-25.
//

import SwiftUI

struct Handle401ErrorModifier: ViewModifier {
    
    @ObservedObject var errorHandler: ErrorHandler
    @ObservedObject var navigationStateManager: NavigationStateManager
    
    func body(content: Content) -> some View {
        content
            .onReceive(errorHandler.$received401, perform: { received401 in
                if received401 {
                    navigationStateManager.goToLogin()
                    errorHandler.resetErrors() // Reset the error state after handling it.
                }
            })
    }
}

extension View {
    func handle401Error(using errorHandler: ErrorHandler, with navigationStateManager: NavigationStateManager) -> some View {
        self.modifier(Handle401ErrorModifier(errorHandler: errorHandler, navigationStateManager: navigationStateManager))
    }
}

