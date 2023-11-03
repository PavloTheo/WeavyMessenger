//
//  MessageView.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-05-31.
//

import SwiftUI

struct MessageView: View {
    
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @EnvironmentObject var messagesViewModel: MessagesViewModel
    @EnvironmentObject var conversationsViewModel: ConversationsViewModel
    @EnvironmentObject var usersViewModel: UsersViewModel
    @EnvironmentObject var errorHandler: ErrorHandler
    
    @State private var messageText: String = ""
    
   
    var body: some View {
        
        VStack(spacing: 0) {
            
        ScrollView {
            
            VStack {
                
               Divider()
                
                if let type = conversationsViewModel.currentConversation?.type {
                    
                    if type.rawValue == "7e14f418-8f15-46f4-b182-f619b671e470" {
                        
                        Text("This is a private chat.")
                        
                    } else if type.rawValue == "edb400ac-839b-45a7-b2a8-6a01820d1c44" {
                        
                        Text("This is a group chat.")
                        
                    }
                }
            }
            
            ForEach(messagesViewModel.messages, id: \.id) { message in
                
                MessageBubbleView(isFromCurrentUser: message.createdBy.id == messagesViewModel.currentUser?.id, text: message.text)
                
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(conversationsViewModel.currentConversation?.displayName ?? "Loading...")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    navigationStateManager.popBack()
                } label: {
                    Image(systemName: "chevron.left.circle")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    navigateToChatInfo()
                 
                }) {
                    Image(systemName: "info.circle")
                }
            }
        }
    }
        .handle401Error(using: errorHandler, with: navigationStateManager)
       
        
        Divider()
        
        HStack {
            TextField("Enter message", text: $messageText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            
            Button(action: {
                print("Send button tapped with message: \(messageText)")
            }) {
                Image(systemName: "paperplane.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding()
            }
        }
        .padding()
    }
       
    func navigateToChatInfo() {
        
        
        if let conversation = conversationsViewModel.currentConversation {
            navigationStateManager.goToChatInfo(conversation: conversation, usersViewModel: usersViewModel)
        }
    }
}




/*struct MessageView_Previews: PreviewProvider {
    
    class MockMessagesViewModel: MessagesViewModel {
        
        static var mockMessage: Message {
            return Message(id: 1, text: "Hello!", html: "<p>Hello!</p>", plain: "Hello!", createdAt: Date(), createdBy: mockUser)
        }
        
        static var mockConversation: Conversation {
            return Conversation(id: 1, typeString: "Chat", uid: "abc123", displayName: "John Doe", avatarURL: URL(string: "https://example.com/avatar.png")!, createdAt: Date(), createdById: 1, modifiedAt: Date(), modifiedById: 1, memberCount: 2, members: [mockUser], userId: 1, lastMessageId: 1, isPinned: false, isUnread: true, isStarred: false, isSubscribed: true, isTrashed: false, lastMessage: nil)
        }
        
        static var mockUser: User {
            return User(id: 1, uid: "sampleUID", displayName: "Joe Stalin", username: "joeySteel", email: "stalin@gmail.com", name: "John Doe", directoryId: nil, pictureId: nil, avatarURL: URL(string: "https://example.com/avatar.png")!, createdAt: Date(), modifiedAt: Date(), isAdmin: true)
        }
        
        override init(apiClient: APIClient, conversation: Conversation, currentUser: User?) {
            let apiClient = APIClient(baseURL: URL(string: "https://mockurl.com")!)
            let conversation = MockMessagesViewModel.mockConversation
            let mockUser = MockMessagesViewModel.mockUser
            super.init(apiClient: apiClient, conversation: conversation, currentUser: mockUser)
            self.messages = [MockMessagesViewModel.mockMessage]
        }
    }
    
    static var previews: some View {
        let mockApiClient = APIClient(baseURL: URL(string: "https://mockurl.com")!)
        let mockConversation = MockMessagesViewModel.mockConversation
        let mockUser = MockMessagesViewModel.mockUser
        let mockMessagesViewModel = MockMessagesViewModel(apiClient: mockApiClient, conversation: mockConversation, currentUser: mockUser)

        let conversationsViewModel = ConversationsViewModel(apiClient: mockApiClient, currentConversation: nil) // Creating an instance of ConversationsViewModel

        return MessageView()
                .environmentObject(NavigationStateManager())
                .environmentObject(mockMessagesViewModel)
                .environmentObject(MessagesViewModel(apiClient: mockApiClient, conversation: mockConversation, currentUser: mockUser))
                .environmentObject(conversationsViewModel)  // Passing the instance instead of the type
    }
}*/

