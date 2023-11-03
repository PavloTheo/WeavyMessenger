//
//  MessageBubbleView.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-08-25.
//

import SwiftUI

struct MessageBubbleView: View {
    
    let isFromCurrentUser: Bool
    let text: String
    
    
    var body: some View {
        
        
        HStack {
            
            if isFromCurrentUser {
                Spacer()
                Text(text)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            } else {
                Text(text)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

struct MessageBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        MessageBubbleView(isFromCurrentUser: true, text: "ok")
    }
}
