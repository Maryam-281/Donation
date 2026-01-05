import Foundation

struct Message: Codable, Identifiable {
    let id: UUID
    let chatId: UUID
    let senderId: UUID
    let receiverId: UUID?
    let text: String
    let imageUrl: String?
    let createdAt: Date
    let readAt: Date?
    
    enum CodingKeys: String, CodingKey {
        case id
        case chatId = "chat_id"
        case senderId = "sender_id"
        case receiverId = "receiver_id"
        case text
        case imageUrl = "image_url"
        case createdAt = "created_at"
        case readAt = "read_at"
    }
    
    // Custom decoder to handle missing fields
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(UUID.self, forKey: .id)
        chatId = try container.decode(UUID.self, forKey: .chatId)
        senderId = try container.decode(UUID.self, forKey: .senderId)
        text = try container.decode(String.self, forKey: .text)
        
        // Optional fields with defaults
        receiverId = try container.decodeIfPresent(UUID.self, forKey: .receiverId)
        imageUrl = try container.decodeIfPresent(String.self, forKey: .imageUrl)
        readAt = try container.decodeIfPresent(Date.self, forKey: .readAt)
        
        // Handle created_at - might be string or date
        if let dateString = try? container.decode(String.self, forKey: .createdAt) {
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            createdAt = formatter.date(from: dateString) ?? Date()
        } else {
            createdAt = try container.decode(Date.self, forKey: .createdAt)
        }
    }
    
    // Regular init for creating messages
    init(id: UUID = UUID(), chatId: UUID, senderId: UUID, receiverId: UUID?, text: String, imageUrl: String? = nil, createdAt: Date = Date(), readAt: Date? = nil) {
        self.id = id
        self.chatId = chatId
        self.senderId = senderId
        self.receiverId = receiverId
        self.text = text
        self.imageUrl = imageUrl
        self.createdAt = createdAt
        self.readAt = readAt
    }
}
