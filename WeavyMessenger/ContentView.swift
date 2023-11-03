//
//  ContentView.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-05-23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var loginVM: LoginViewModel
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @EnvironmentObject var conversationsViewModel: ConversationsViewModel
    @EnvironmentObject var usersViewModel: UsersViewModel
    @EnvironmentObject var authentication: Authentication
  
    
    var body: some View {
        
        NavigationStack(path: $navigationStateManager.selectionPath) {
            Group {
                if authentication.isAuthenticated {
                    ConversationsView()
                } else {
                    LoginView(loginVM: loginVM)
                }
            }
            .alert(isPresented: $errorHandler.received401) {
                if errorHandler.isIntentionalLogout {
                    DispatchQueue.main.async {
                        errorHandler.isIntentionalLogout = false
                    }
                    return Alert(title: Text("Logged Out"),
                                 message: Text("You have been logged out successfully."),
                                 dismissButton: .default(Text("OK")))
                } else {
                    return Alert(title: Text("Authentication Error"),
                                 message: Text("You have been logged out due to an authentication issue. Please log in again."),
                                 dismissButton: .default(Text("OK"), action: {
                                     authentication.logOut()
                    }))
                }
            }

            
            .navigationDestination(for: SelectionState.self) { state in
                  
                  switch state {
                      
                  case .conversation(let selectedConversation):
                      let apiClient = APIClient(baseURL: URL(string: WeavyAPIConfig.weavyServerBaseURL)!, errorHandler: errorHandler)
                      let messagesViewModel = MessagesViewModel(apiClient: apiClient, conversation: selectedConversation, currentUser: usersViewModel.currentUser)
                      MessageView()
                          .environmentObject(messagesViewModel)
                          .environmentObject(usersViewModel)

                  case .settings:
                      SettingsView().environmentObject(usersViewModel)
                      
                  case .newConversation:
                      NewConversationView()
                      
                  case .groupChatInfo(let conversation):
                      GroupChatInfoView(conversation: conversation)
                          .environmentObject(usersViewModel)
                          
                  case .privateChatInfo(let member, let conversation):
                      PrivateChatInfoView(member: member, conversation: conversation)
                          .environmentObject(usersViewModel)
                  case .loginPage:
                      LoginView(loginVM: loginVM)
                }
            }
        
        }
        VStack {
            Text("Path")
            Text("number of detail views on the stack: \($navigationStateManager.selectionPath.count)")
            } // keeps track of number of views on the stack, for navigation purposes
    }
}

struct ContentView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        let errorHandler = ErrorHandler()
        let dummyAPIClient = APIClient(baseURL: URL(string: "https://dummyurl.com")!, errorHandler: errorHandler)
        let authentication = Authentication()

        ContentView()
            .environmentObject(LoginViewModel())
            .environmentObject(NavigationStateManager())
            .environmentObject(ConversationsViewModel(apiClient: dummyAPIClient, currentConversation: nil))
            .environmentObject(UsersViewModel(apiClient: dummyAPIClient))
            .environmentObject(errorHandler)
            .environmentObject(authentication)

    }
}
