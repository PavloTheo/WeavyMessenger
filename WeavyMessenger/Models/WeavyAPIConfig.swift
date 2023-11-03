//
//  WeavyAPIConfig.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-06-01.
//

import Foundation

struct WeavyAPIConfig {
    
    // Base URLs
    static let appServerBaseURL = "https://weavy-hq.azurewebsites.net"
    static let weavyServerBaseURL = "https://weavy-hq.weavy.io"
    
    
    // App Server endpoints
    static let appServerTokenEndpoint = "/api/tokens"
    
    
    // Weavy Server endpoints
    static let getConversations = "/api/conversations" // lists the active conversations for the authenticated user. Has Data struct.
    static let getConversation = "/api/conversations/{id}" // fetches information about specific conversation. No Data struct.
    static let getMessages = "/api/apps/{id}/messages" // gets the messages in a conversation. Has Data struct.
    static let getUsers = "/api/users" // lists the authenticated user's chat buddies. Has Data struct.
    static let getUser = "/api/user" // gets the authenticated user. No Data struct.
    static let getMembers = "/api/apps/{id}/members" // lists the members and their info for a specific conversation. Has Data struct.
    
}
