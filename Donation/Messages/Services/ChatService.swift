import Foundation
import Supabase

class ChatService {
    private let supabase = SupabaseService.shared.client  // ← Changed
    private let userService = UserService()
    
    // Rest stays the same...
    
    func createChat(participantIds: [UUID]) async throws -> UUID {
        if let existingChatId = try await findExistingChat(between: participantIds) {
            return existingChatId
        }
        
        let chatId = participantIds[0]
        
        let newChat: [String: String] = [
            "id": chatId.uuidString
        ]
        
        let _: EmptyResponse = try await supabase
            .from("chats")
            .insert(newChat)
            .execute()
            .value
        
        for userId in participantIds {
            let participant: [String: String] = [
                "chat_id": chatId.uuidString,
                "user_id": userId.uuidString
            ]
            
            let _: EmptyResponse = try await supabase
                .from("chat_participants")
                .insert(participant)
                .execute()
                .value
        }
        
        return chatId
    }
    
    private func findExistingChat(between userIds: [UUID]) async throws -> UUID? {
        guard userIds.count == 2 else { return nil }
        
        struct ParticipantResponse: Codable {
            let chat_id: String
        }
        
        let user1Chats: [ParticipantResponse] = try await supabase
            .from("chat_participants")
            .select("chat_id")
            .eq("user_id", value: userIds[0].uuidString)
            .execute()
            .value
        
        let user2Chats: [ParticipantResponse] = try await supabase
            .from("chat_participants")
            .select("chat_id")
            .eq("user_id", value: userIds[1].uuidString)
            .execute()
            .value
        
        let user1ChatIds = Set(user1Chats.map { $0.chat_id })
        let user2ChatIds = Set(user2Chats.map { $0.chat_id })
        let commonChats = user1ChatIds.intersection(user2ChatIds)
        
        return commonChats.first.flatMap { UUID(uuidString: $0) }
    }
    
    func getUserChatsWithDetails(userId: UUID) async throws -> [ChatWithParticipant] {
        struct ParticipantResponse: Codable {
            let chat_id: String
        }
        
        let participations: [ParticipantResponse] = try await supabase
            .from("chat_participants")
            .select("chat_id")
            .eq("user_id", value: userId.uuidString)
            .execute()
            .value
        
        let chatIds = participations.compactMap { $0.chat_id }
        guard !chatIds.isEmpty else { return [] }
        
        let chats: [Chat] = try await supabase
            .from("chats")
            .select()
            .in("id", values: chatIds)
            .order("created_at")
            .execute()
            .value
        
        var chatsWithDetails: [ChatWithParticipant] = []
        
        for chat in chats {
            let participants = try await getChatParticipants(chatId: chat.id)
            let otherUserId = participants.first { $0 != userId } ?? userId
            
            let otherUser = try await userService.getUser(id: otherUserId)
            let lastMessage = try? await getLastMessage(chatId: chat.id)
            
            chatsWithDetails.append(ChatWithParticipant(
                chat: chat,
                otherUser: otherUser,
                lastMessage: lastMessage
            ))
        }
        
        return chatsWithDetails
    }
    
    func getChatParticipants(chatId: UUID) async throws -> [UUID] {
        struct ParticipantResponse: Codable {
            let user_id: String
        }
        
        let participants: [ParticipantResponse] = try await supabase
            .from("chat_participants")
            .select("user_id")
            .eq("chat_id", value: chatId.uuidString)
            .execute()
            .value
        
        return participants.compactMap { UUID(uuidString: $0.user_id) }
    }
    
    private func getLastMessage(chatId: UUID) async throws -> Message {
        let messages: [Message] = try await supabase
            .from("messages")
            .select()
            .eq("chat_id", value: chatId.uuidString)
            .order("created_at")
            .limit(1)
            .execute()
            .value
        
        guard let lastMessage = messages.first else {
            throw NSError(domain: "ChatService", code: 404, userInfo: ["NSLocalizedDescriptionKey": "No messages found"])
        }
        
        return lastMessage
    }
}
