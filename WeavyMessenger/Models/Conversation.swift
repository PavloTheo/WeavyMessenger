//
//  Conversation.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-06-07.
//

import Foundation

struct Conversation: Identifiable, Codable, Equatable, Hashable {
    
    let id: Int
    let typeString: String
    let uid: String?
    let displayName: String
    let name: String?
    let avatarURL: URL?
    let createdAt: Date
    let createdById: Int
    let modifiedAt: Date?
    let modifiedById: Int?
    let memberCount: Int?
    var members: [Member]?
    let userId: Int?
    let lastMessageId: Int?
    let isPinned: Bool?
    let isUnread: Bool?
    let isStarred: Bool?
    let isSubscribed: Bool
    let isTrashed: Bool?
    
    
    
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case typeString = "type"
        case uid
        case displayName = "display_name"
        case name                          // Added after working app
        case avatarURL = "avatar_url"
        case createdAt = "created_at"
        case createdById = "created_by_id"
        case modifiedAt = "modified_at"
        case modifiedById = "modified_by_id"
        case memberCount = "member_count"
        case members
        case userId = "user_id"
        case lastMessageId = "last_message_id"
        case isPinned = "is_pinned"
        case isUnread = "is_unread"
        case isStarred = "is_starred"
        case isSubscribed = "is_subscribed"
        case isTrashed = "is_trashed"
        case lastMessage = "last_message"
        
        
        
    }
    
    var type: ConversationType? {
        return ConversationType(rawValue: typeString)
    }
    
    
  
    
    enum ConversationType: String {
        case privateChat = "7e14f418-8f15-46f4-b182-f619b671e470"
        case groupChat = "edb400ac-839b-45a7-b2a8-6a01820d1c44"
        case unknown
    }
    
    let lastMessage: LastMessage?
    
    struct LastMessage: Codable, Equatable, Hashable {
        let id: Int
        let text: String
        let html: String // new
        let plain: String
     //   let attachmentCount: Int?
     //   let attachments: [Attachment]?
        
        struct Attachment: Codable, Equatable, Hashable {
            let id: Int
            let name: String
            let kind: String
            let mediaType: String?
            let width: Int?
            let height: Int?
            let size: Int?
            let downloadUrl: String?
            let thumbnailUrl: String?
            
            enum CodingKeys: String, CodingKey {
                case id, name, kind
                case mediaType = "media_type"
                case width, height, size
                case downloadUrl = "download_url"
                case thumbnailUrl = "thumbnail_url"
            }
        }
    }
}

extension Conversation {
    var isPrivateChat: Bool {
        return type == .privateChat
    }
    var isGroupChat: Bool {
        return type == .groupChat
    }
}
