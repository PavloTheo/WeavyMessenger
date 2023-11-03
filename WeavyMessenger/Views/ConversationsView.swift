//
//  ConversationsView.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-05-23.
//

import SwiftUI
import ListPagination

struct ConversationsView: View {
    
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @EnvironmentObject var usersViewModel: UsersViewModel
    @EnvironmentObject var conversationsViewModel: ConversationsViewModel
    @EnvironmentObject var errorHandler: ErrorHandler
    @EnvironmentObject var authentication: Authentication

    
    @State private var isLoading: Bool = false
    @State private var page: Int = 0
    @State private var searchText = ""
    @State private var searchIsActive = false
    
    @SceneStorage("navigationState") var navigationStateData: Data?
    
    private let pageSize: Int = 10 // or whatever size we want
    private let offset: Int = 3 // how many items from the end before you start loading
    
    
    var body: some View {
        
        VStack {

                List {
                    
                    Section(header: Text("Conversations")) {
                        
                        ForEach(conversationsViewModel.conversations.indices, id: \.self) { index in
                            HStack(alignment: .top) {
                                // Profile Picture
                                
                                if let url = conversationsViewModel.conversations[index].avatarURL {
                                    AvatarView(url: url, size: CGSize(width: 50, height: 50))
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.fil")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 50, height: 50)
                                        .foregroundColor(.gray)
                                }
                                
                                // Participant's name and last message
                                
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(conversationsViewModel.conversations[index].displayName)
                                        .font(.headline)
                                    
                                    if let lastMessageText = conversationsViewModel.conversations[index].lastMessage?.plain {
                                        Text(lastMessageText)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }
                                Spacer() // pushes the text to the leading edge
                            }
                            .contentShape(Rectangle()) // makes entire row tapable.
                            .onTapGesture {
                                
                                let conversationID = conversationsViewModel.conversations[index].id
                                
                                conversationsViewModel.selectConversation(atIndex: index)
                                navigationStateManager.goToConversation(conversation: conversationsViewModel.conversations[index])
                                Task {
                                    await conversationsViewModel.fetchMembersForConversation(by: conversationID)
                                }
                            }
                            .background(
                                GeometryReader { proxy in
                                    Color.clear.onAppear {
                                        print("item at index \(index) appeared")
                                        if shouldLoadMoreItems(currentIndex: index) {
                                            loadMoreConversations()
                                        }
                                    }
                                }
                            )
                        }
                    }
                    if isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Messenger")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            navigationStateManager.goToSettings()
                        } label: {
                            if let avatarURL = usersViewModel.currentUser?.avatarURL {
                                AvatarView(url: avatarURL, size: CGSize(width: 30, height: 30))
                                    .clipShape(Circle())
                            } else {
                                // Fallback to gear icon if avatar is not available
                                Image(systemName: "gear")
                            }
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            navigationStateManager.goToNewConversation()
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .navigationBarBackButtonHidden(true)
                .searchable(text: $searchText)
            }
         //   .handle401Error(using: errorHandler, with: navigationStateManager)
            .onAppear {
                page = 0
                Task {
                    print("Fetching initial conversations at \(Date())")
                    print("App is started")
                    if authentication.isAuthenticated {
                        await usersViewModel.fetchCurrentUser()
                        await conversationsViewModel.fetchConversations(page: page, pageSize: pageSize)
                    } else {
                        // Maybe good place for stopping calls while not logged in.
                    }
                    
            }
        }
    }
    
    func shouldLoadMoreItems(currentIndex: Int) -> Bool {
        let offset: Int = 15
        if !isLoading && conversationsViewModel.initialLoadCompleted && currentIndex == conversationsViewModel.conversations.count - offset {
            return true
        }
        return false
    }

    
    func loadMoreConversations() {
        guard !isLoading else { return }
        isLoading = true
        page += 1
        
        Task {
            defer { isLoading = false }
            print("Fetching more conversations due to pagination at \(Date())")
            await conversationsViewModel.fetchConversations(page: page, pageSize: pageSize)
        }
    }
}

struct ConversationsView_Previews: PreviewProvider {
    static var previews: some View {
        let errorHandler = ErrorHandler()
        let apiClient = APIClient(baseURL: URL(string: WeavyAPIConfig.weavyServerBaseURL)!, errorHandler: errorHandler)
        
        return ConversationsView()
            .environmentObject(NavigationStateManager())
            .environmentObject(UsersViewModel(apiClient: apiClient))
            .environmentObject(ConversationsViewModel(apiClient: apiClient, currentConversation: nil))
            .environmentObject(errorHandler)
    }
}
