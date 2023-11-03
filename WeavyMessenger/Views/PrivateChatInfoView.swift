//
//  PrivateChatInfoView.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-09-05.
//

import SwiftUI

struct PrivateChatInfoView: View {
    
    @EnvironmentObject var navigationStateManager: NavigationStateManager
    @EnvironmentObject var usersViewModel: UsersViewModel
    @EnvironmentObject var messagesViewModel: MessagesViewModel
    @EnvironmentObject var errorHandler: ErrorHandler
    
    var member: Member
    var conversation: Conversation
    
    
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding()
            
            Text("Chat with \(member.displayName)")
                .font(.headline)

            Spacer()
            
        }
        .background(Color.purple)
        .background(Color.yellow)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Private Chat")
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

/*struct PrivateChatInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PrivateChatInfoView(user: User(id: 1, uid: "sampleUID", displayName: "Joe Stalin", username: "joeySteel", email: "stalin@gmail.com", name: "John Doe", directoryId: nil, pictureId: nil, avatarURL: URL(string: "https://example.com/avatar.png")!, createdAt: Date(), modifiedAt: Date(), isAdmin: true))
    }
}*/
