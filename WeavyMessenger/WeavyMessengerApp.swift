//
//  WeavyMessengerApp.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-05-23.
//

import SwiftUI

@main

struct WeavyMessengerApp: App {
    
    @StateObject private var errorHandler: ErrorHandler
    @StateObject private var loginVM = LoginViewModel()
    @StateObject private var navigationStateManager = NavigationStateManager()
    @StateObject private var usersViewModel: UsersViewModel
    @StateObject private var conversationsViewModel: ConversationsViewModel

    init() {
        let tempErrorHandler = ErrorHandler()
        let apiClient = APIClient(baseURL: URL(string: WeavyAPIConfig.weavyServerBaseURL)!, errorHandler: tempErrorHandler)
        
        _errorHandler = StateObject(wrappedValue: tempErrorHandler)
        _usersViewModel = StateObject(wrappedValue: UsersViewModel(apiClient: apiClient))
        _conversationsViewModel = StateObject(wrappedValue: ConversationsViewModel(apiClient: apiClient, currentConversation: nil))
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(loginVM)
                .environmentObject(navigationStateManager)
                .environmentObject(usersViewModel)
                .environmentObject(conversationsViewModel)
                .environmentObject(errorHandler)
                .environmentObject(Authentication.shared)
        }
    }
}
