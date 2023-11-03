//
//  UsersViewModel.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-06-02.
//

import Foundation
import Combine

class UsersViewModel: ObservableObject {
    
    
    
    @Published var currentUser: User? = nil
    @Published var users: [User] = []
    
    private let apiClient: APIClient
    private let authentication: Authentication
 //   private let errorHandler: ErrorHandler
    
    init(apiClient: APIClient, authentication: Authentication = Authentication.shared) {
        self.apiClient = apiClient
        self.authentication = authentication
    }
    
    @MainActor
    
    func fetchCurrentUser() async {
        do {
            let user = try await apiClient.getUser()
            self.currentUser = user
            print("UsersViewModel after fetching currentUser: \(Unmanaged.passUnretained(self).toOpaque())")
        } /*catch errorHandler.received401 {
            print("Unauthorized. User needs to be logged out.")
            logOut()
        }*/ catch let error as DecodingError {
            print("Decoding error: \(error)")
        } catch {
            print("Failed to fetch current user: \(error)")
        }
    }
    
    @MainActor
    
    func fetchUsers() async {
        do {
            let fetchedUsers = try await apiClient.getUsers()
            self.users = fetchedUsers
            print("Fetched \(fetchedUsers.count) users.")
        }/* catch APIClient.NetworkError.unauthorized {
            print("Unauthorized. User needs to be logged out.")
            logOut()
        }*/ catch {
            print("Error fetching users: \(error)")
        }
    }
}
