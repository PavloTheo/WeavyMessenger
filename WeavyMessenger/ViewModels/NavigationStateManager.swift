//
//  NavigationStateManager.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-05-25.
//

import Foundation
import Combine

enum SelectionState: Hashable, Codable {
    
    case conversation(Conversation)
    case settings
    case newConversation
    case groupChatInfo(Conversation) // Group chat
    case privateChatInfo(Member, Conversation) // Private chat
    case loginPage
    
}

class NavigationStateManager: ObservableObject {
    
    @Published var selectionPath = [SelectionState]()
    @Published var membersData: [Member] = []
    
    private var authentication = Authentication()

    var data: Data? {
        get {
            let encodedData = try? JSONEncoder().encode(selectionPath)
            print("encoded data")
            return encodedData
        }
        set {
            
            guard let data = newValue,
                    let path = try? JSONDecoder().decode([SelectionState].self, from: data) else {
                return
            }
            
            // fetch updated new model data for each id
            self.selectionPath = path
        }
    }
    
    func popBack() {
        selectionPath.removeLast()
    }
    
    func goToSettings() {
        selectionPath = [SelectionState.settings]
    }
    
    func goToNewConversation() {
        selectionPath = [SelectionState.newConversation]
    }
    
    func goToConversation(conversation: Conversation) {
        selectionPath = [SelectionState.conversation(conversation)]
    }
    
   /* func goToChatInfo(conversation: Conversation, usersViewModel: UsersViewModel, messagesViewModel: MessagesViewModel, conversationsViewModel: ConversationsViewModel) {
        
        print("Attempting to go to Chat Info for conversation: \(conversation.displayName)")
        print("1 Conversation members: \(String(describing: conversation.members))")
   
        guard let members = conversation.members, !members.isEmpty else {
            print("No members found or members not yet loaded")
            return
        }

        switch conversation.type?.rawValue {
            
        case ConversationType.privateChat.rawValue: // Raw value for one-on-one chat
            if let otherParticipantID = messagesViewModel.otherParticipantID,
               let otherMember = members.first(where: { $0.id == otherParticipantID }) {
                selectionPath.append(SelectionState.privateChatInfo(otherMember, conversation))
            } else {
                print("Error finding other participant")
            }
            print("2 Conversation members: \(String(describing: conversation.members))")
            print("Current user: \(String(describing: usersViewModel.currentUser))")
            
            
        case "edb400ac-839b-45a7-b2a8-6a01820d1c44": // Raw value for group chat
            selectionPath.append(SelectionState.groupChatInfo(conversation))
        default:
            print("Unknown conversation type")
        }
    }*/
    
    func goToChatInfo(conversation: Conversation, usersViewModel: UsersViewModel) {
        
        print("Attempting to go to Chat Info for conversation: \(conversation.displayName)")
        print("1 Conversation members: \(String(describing: conversation.members))")
   
        guard let members = conversation.members, !members.isEmpty else {
            print("No members found or members not yet loaded")
            return
        }

        if conversation.isPrivateChat {
            if let currentUserID = usersViewModel.currentUser?.id,
               let otherMember = members.first(where: { $0.id != currentUserID }) {
                selectionPath.append(SelectionState.privateChatInfo(otherMember, conversation))
            } else {
                print("Error finding other participant")
            }
        } else if conversation.isGroupChat {
            selectionPath.append(SelectionState.groupChatInfo(conversation))
        } else {
            print("Unknown conversation type")
        }
    }
    
    func goToLogin() {
        print("NavigationStateManager: goToLogin was called. New selectionPath: \(selectionPath)")
        selectionPath = [SelectionState.loginPage]
        if authentication.isAuthenticated == false {
            selectionPath = []
        }
    }
    
    var objectWillChangeSequence: AsyncPublisher<Publishers.Buffer<ObservableObjectPublisher>> {
        objectWillChange
            .buffer(size: 1, prefetch: .byRequest, whenFull: .dropOldest)
            .values
    }
}
