//
//  NewConversationView.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-05-29.
//

import SwiftUI

struct NewConversationView: View {
    
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @EnvironmentObject var usersViewModel: UsersViewModel
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var conversationsViewModel: ConversationsViewModel
    
    @State private var searchText = ""
    @State private var searchIsActive = false
    @State private var selection = Set<String>()
    
    var body: some View {
        
        VStack {
            
            List {
                Section(header: Text("New Conversation")) {
                    
                    ForEach(usersViewModel.users, id: \.id) { user in
                        
                        HStack {
                            
                          
             
                            Text(user.name ?? "Unknown User")
                        }
                        .contentShape(Rectangle()) // makes entire row tapable.
                    }
                    
                }
            }
            .searchable(text: $searchText)
        }
        .onAppear {
            Task {
                await usersViewModel.fetchUsers()
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("New Conversation")
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

struct NewConversationView_Previews: PreviewProvider {
    static var previews: some View {
        let errorHandler = ErrorHandler()
        let apiClient = APIClient(baseURL: URL(string: "https://weavy-hq.weavy.io")!, errorHandler: errorHandler)
        let usersViewModel = UsersViewModel(apiClient: apiClient)
        
        return NewConversationView()
            .environmentObject(NavigationStateManager())
            .environmentObject(usersViewModel)
            .environmentObject(errorHandler)
    }
}
