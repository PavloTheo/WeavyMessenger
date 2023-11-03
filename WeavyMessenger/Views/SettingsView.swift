//
//  SettingsView.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-05-31.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @EnvironmentObject var usersViewModel: UsersViewModel
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var authentication: Authentication
    
    
    var body: some View {
        
        VStack {
            
            if let avatarURL = usersViewModel.currentUser?.avatarURL {
                AvatarView(url: avatarURL, size: CGSize(width: 100, height: 100))
                    .clipShape(Circle())
            } else {
                
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                
            }
            
            HStack {
                
                VStack(alignment: .leading, spacing: 6){
                
                    if let user = usersViewModel.currentUser {
                            
                            VStack {
                                Text("Current user: \(user.displayName)")
                                Text("Username: \(user.name ?? "N/A")")
                                Text("Email: \(user.email ?? "N/A")")
                             }
                        } else {
                            Text("Loading")
                    }
                }
            }
            .padding(.vertical, 20)
            
                Button {
                    print("Logout button tapped!")
                    errorHandler.isIntentionalLogout = true
                    authentication.logOut()
                } label: {
                    Text("Log out")
                }
         }
        .onChange(of: authentication.isAuthenticated) { isAuthenticated in
            if !isAuthenticated {
                navigationStateManager.goToLogin()
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Settings")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    navigationStateManager.popBack()
                } label: {
                    Image(systemName: "chevron.left.circle")
                }
            }
        }
        .handle401Error(using: errorHandler, with: navigationStateManager)
    }
}

struct SettingsViewStack_Previews: PreviewProvider {
    static var previews: some View {
        let errorHandler = ErrorHandler()
        let authentication = Authentication()
        SettingsView()
            .environmentObject(UsersViewModel(apiClient: APIClient(baseURL: URL(string: WeavyAPIConfig.weavyServerBaseURL)!, errorHandler: errorHandler)))
            .environmentObject(errorHandler)
            .environmentObject(NavigationStateManager())
            .environmentObject(authentication)
    }
}
