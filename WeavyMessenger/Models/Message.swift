//
//  Message.swift
//  WeavyMessenger
//
//  Created by Pavlo Theodoridis on 2023-05-29.
//

import Foundation

struct Message: Codable, Equatable, Hashable, Identifiable {
    
        let id: Int
        let text: String
        let html: String
        let plain: String
        let createdAt: Date
        let createdBy: User
        
        enum CodingKeys: String, CodingKey {
            case id
            case text
            case html
            case plain
            case createdAt = "created_at"
            case createdBy = "created_by"
    }
}
