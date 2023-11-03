//
//  User.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-06-02.
//

import Foundation

struct User: Identifiable, Codable, Equatable, Hashable {
    
    let id: Int
    let uid: String?
    let displayName: String
    let username: String?
    let email: String?
    let name: String?
    let directoryId: Int?
    let pictureId: Int?
    let avatarURL: URL?
    let createdAt: Date?
    let modifiedAt: Date?
    let isAdmin: Bool?
    let deliveredAt: Date?
    let markedAt: Date?
    let markedId: Int?
    let presence: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case uid
        case displayName = "display_name"
        case username
        case email
        case name
        case directoryId = "directory_id"
        case pictureId = "picture_id"
        case avatarURL = "avatar_url"
        case createdAt = "created_at"
        case modifiedAt = "modified_at"
        case isAdmin = "is_admin"
        case deliveredAt = "delivered_at"
        case markedAt = "marked_at"
        case markedId = "marked_id"
        case presence
    }
}
