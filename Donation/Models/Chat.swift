import Foundation

struct Chat: Codable, Identifiable {
    let id: UUID
    let createdAt: Date
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
    }
}

// Extended chat with participant info
struct ChatWithParticipant: Identifiable {
    let chat: Chat
    let otherUser: User
    let lastMessage: Message?
    
    var id: UUID { chat.id }
}
