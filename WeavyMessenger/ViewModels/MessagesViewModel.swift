//
//  MessagesViewModel.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-08-15.
//

import Foundation

class MessagesViewModel: ObservableObject {
    
    @Published var messages: [Message] = []
    @Published var otherParticipantID: Int?
    
    private let apiClient: APIClient
    
    let currentUser: User?
    
    init(apiClient: APIClient, conversation: Conversation, currentUser: User?) {
        self.apiClient = apiClient
        self.currentUser = currentUser
     
  
        print("MessagesViewModel initialized")
        print("MessagesViewModel initialized with user: \(String(describing: currentUser))")
        Task {
            await fetchMessagesForConversation(by: conversation.id)
  
        }
    }
    
   func fetchMessagesForConversation(by id: Int) async {
       
       self.messages = []
        
        print("(MessagesViewModel) Fetching messages for conversation ID \(id)")
        
        do {
            let fetchedMessages = try await apiClient.getMessages(forConversationID: id)
            DispatchQueue.main.async {
                self.messages = fetchedMessages
            }
        } catch {
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .dataCorrupted(let context):
                    print("Data corrupted: \(context)")
                    
                default:
                    break
                }
            }
            print("Error fetching messages: \(error). Description: \(error.localizedDescription)")
        }
    }
    
    func sendMessage() {
        
    }

  /*  func loadMockData() {
        
       let mockUser = User(id: 1,
                           uid: "mockUID123",
                           displayName: "Mock User",
                           username: "mockuser",
                           email: "mockuser@example.com",
                           name: "Mock User Name",
                           directoryId: 12345,
                           pictureId: 12345,
                           avatarURL: URL(string: "https://example.com/avatar.jpg")!,
                           createdAt: Date().addingTimeInterval(-3600 * 24 * 7),
                           modifiedAt: Date().addingTimeInterval(-3600 * 24 * 6), isAdmin: true)
        
    self.messages = [
        Message(id: 1,
                text: "Hello there!",
                html: "<p>Hello there!</p>",
                plain: "Hello there!",
                createdAt: Date(),
                createdBy: mockUser),
        Message(id: 2,
                text: "Eddard!",
                html: "<p>Eddard!</p>",
                plain: "Eddard!",
                createdAt: Date(),
                createdBy: mockUser)]
    }*/
}

