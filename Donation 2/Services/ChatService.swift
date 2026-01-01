import Foundation
import Supabase

class ChatService {
    private let supabase = SupabaseManager.shared.client
    
    // Create a new chat with participants
    func createChat(participantIds: [UUID]) async throws -> UUID {
        // Create the chat - insert empty dictionary
        struct ChatInsertResponse: Codable {
            let id: String
            let created_at: String
        }
        
        let response: [ChatInsertResponse] = try await supabase
            .from("chats")
            .insert(["id": UUID().uuidString])
            .select()
            .execute()
            .value
        
        guard let chatIdString = response.first?.id,
              let chatId = UUID(uuidString: chatIdString) else {
            throw NSError(domain: "ChatService", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to create chat"])
        }
        
        // Add participants
        for userId in participantIds {
            let participant: [String: String] = [
                "chat_id": chatId.uuidString,
                "user_id": userId.uuidString
            ]
            
            struct EmptyResponse: Codable {}
            let _: [EmptyResponse] = try await supabase
                .from("chat_participants")
                .insert(participant)
                .execute()
                .value
        }
        
        return chatId
    }
    
    // Get all chats for current user
    func getUserChats(userId: UUID) async throws -> [Chat] {
        // First get chat IDs where user is a participant
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
        
        // Custom decoder for dates
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        // Then get the actual chat details
        let response: [Chat] = try await supabase
            .from("chats")
            .select()
            .in("id", values: chatIds)
            .order("created_at")
            .execute()
            .value
        
        return response
    }
    
    // Get participants for a chat
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
    
    // Delete a chat
    func deleteChat(chatId: UUID) async throws {
        struct EmptyResponse: Codable {}
        let _: [EmptyResponse] = try await supabase
            .from("chats")
            .delete()
            .eq("id", value: chatId.uuidString)
            .execute()
            .value
    }
}
