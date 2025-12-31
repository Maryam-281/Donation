//
//  Chat.swift
//  Donation
//
//  Created by BP-36-201-19 on 31/12/2025.
//

import Foundation

struct Chat: Codable, Identifiable {
    let id: UUID
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
    }
}
