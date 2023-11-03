//
//  ConversationsViewModel.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-06-02.
//

import Foundation

class ConversationsViewModel: ObservableObject {
    
    @Published var conversations: [Conversation] = [] // Array holds fetched conversations
    @Published var initialLoadCompleted: Bool = false // property to ensure fetch Conversations isn't done twice simultaneously (pagination)
    @Published var currentConversation: Conversation? // Holds the currently selected conversation object.
    @Published var members: [Member]
    
    @Published var isLoadingConversations: Bool = false
    @Published var isLoadingMembers: Bool = false
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient, currentConversation: Conversation?) { // Initializes the 'apiClient' and 'currentConversation' with the passed values.
        self.apiClient = apiClient
        self.currentConversation = currentConversation
        self.members = []
    }
    
    func fetchConversations(page: Int, pageSize: Int) async {
        do {
            let fetchedConversations = try await apiClient.getConversations()
            DispatchQueue.main.async {
                self.conversations = fetchedConversations
                self.currentConversation = fetchedConversations.first // populated correctly
                self.initialLoadCompleted = true
            }
        } catch APIClient.NetworkError.unauthorized {
            print("Unauthorized. User needs to be logged out.")
            // TODO: Log out user or take another action if necessary
        } catch let decodingError as DecodingError {
            switch decodingError {
             case .dataCorrupted(let context):
                 print("Data corrupted: \(context)")
             case .keyNotFound(let key, let context):
                 print("Key '\(key.stringValue)' not found: \(context.debugDescription)")
             case .typeMismatch(let type, let context):
                 print("Type '\(type)' mismatch: \(context.debugDescription)")
             case .valueNotFound(let type, let context):
                 print("Value '\(type)' not found: \(context.debugDescription)")
             @unknown default:
                 print("Unknown decoding error: \(decodingError)")
            }
        } catch {
            print("Failed to fetch conversations: \(error)")
        }
    }

    
    func selectConversation(atIndex index: Int) {
        guard index < conversations.count else { return }
        self.currentConversation = conversations[index] // populated correctly 
    }
    
    
    func fetchMembersForConversation(by id: Int) async {
        
      print("(CVM) Fetching members for conversation ID \(id)") // Works
            do {
                    let fetchedMembers = try await apiClient.getMembers(forMembersID: id)
              print("Fetched members (ConversationsViewModel): \(fetchedMembers)") // Works
              
                DispatchQueue.main.async {
                  
                  if let index = self.conversations.firstIndex(where: { $0.id == id }) {
                      self.conversations[index].members = fetchedMembers // correctly populated "fetchedMembers".
                      
                      print("(CVM) Updated conversation: \(self.conversations[index])") // Works
                      
                      // Now the conversation with the specific id has the updated members information
                  } else {
                      // Handle case where conversation with specific id is not found in the conversations array
                      print("Conversation with ID \(id) not found")
                  }
                  
                  self.members = fetchedMembers
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
              print("Error fetching members: \(error). Description: \(error.localizedDescription)")
        }
    }
}
