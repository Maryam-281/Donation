//
//  Message.swift
//  Donation
//
//  Created by BP-36-201-19 on 31/12/2025.
//

import Foundation

struct Message: Codable, Identifiable {
    let id: UUID
    let chatId: UUID
    let senderId: UUID
    let text: String
    let createdAt: Date
    let readAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case chatId = "chat_id"
        case senderId = "sender_id"
        case text
        case createdAt = "created_at"
        case readAt = "read_at"
    }
}
