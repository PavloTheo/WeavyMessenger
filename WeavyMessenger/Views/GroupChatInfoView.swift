//
//  GroupChatInfoView.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-09-05.
//

import SwiftUI

struct GroupChatInfoView: View {
    
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @EnvironmentObject var messagesViewModel: MessagesViewModel
    @EnvironmentObject var errorHandler: ErrorHandler
    
    var conversation: Conversation

    var body: some View {
        VStack {
            Image(systemName: "person.3")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .padding()
            
            Text("Group: \(conversation.displayName)")
                .font(.headline)
            Spacer()
        }
        .background(Color.yellow)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Group Chat")
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

struct GroupChatInfoView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        GroupChatInfoView(conversation: Conversation(id: 1, typeString: "Chat", uid: "abc123", displayName: "John Doe", name: "", avatarURL: URL(string: "https://example.com/avatar.png")!, createdAt: Date(), createdById: 1, modifiedAt: Date(), modifiedById: 1, memberCount: 2, userId: 1, lastMessageId: 1, isPinned: false, isUnread: true, isStarred: false, isSubscribed: true, isTrashed: false, lastMessage: nil))
            .environmentObject(ErrorHandler())
            .environmentObject(NavigationStateManager())
    }
}

