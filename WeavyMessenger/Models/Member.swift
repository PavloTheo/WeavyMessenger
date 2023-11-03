//
//  Member.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-09-11.
//

import Foundation

struct MemberResponse: Codable {
    let data: [Member]
    let start: Int
    let end: Int
    let count: Int
}

struct Member: Identifiable, Codable, Equatable, Hashable {
    let id: Int
    let uid: String
    let displayName: String
    let avatarUrl: URL?
    let deliveredAt: Date?
    let markedAt: Date?
    let markedId: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case uid
        case displayName = "display_name"
        case avatarUrl = "avatar_url"
        case deliveredAt = "delivered_at"
        case markedAt = "marked_at"
        case markedId = "marked_id"
    }
}
