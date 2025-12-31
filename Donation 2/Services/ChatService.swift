//
//  ChatService.swift
//  Donation
//
//  Created by BP-36-201-19 on 31/12/2025.
//

import Foundation
import Supabase

class ChatService {
    private let supabase = SupabaseManager.shared.client
    
    //Create a new chat with participants
    func createChat(participantsIds: [UUID]) async throws -> UUID {
        //Creating the chat
        let newChat: Chat = try await supabase
            .from("chats")
            .insert([:])
            .select()
            .single()
            .execute()
            .value
        
        //Add Participants
        for userId in participantsIds {
            let participant: [String: Any] = [
                "chat_id": newChat.id.uuidString,
                "user_id": userId.uuidString
            ]
            
            try await supabase
                .from("chat_participants")
                .insert(participant)
                .execute()
        }
        return newChat.id
    }
    
    func getUserChats(userId: UUID) async throws -> [Chat] {
        //Get chat IDs where the current user is a participant in
        struct ParticipantResponse: Codable {
            let chat_id: String
        }
        
        let participations: [ParticipantResponse] = try await supabase
        .from("chat_participants")
        .select("chat_id")
        .eq("user_id", value: userId.uuidString)
        .execute()
        .value
        
        let chatIds = participations.compactMap { $0.chat_id}
        
        guard !chatIds.isEmpty else {
            return []
        }
        
        let chats: [Chat] = try await supabase
            .from("chats")
            .select()
            .in("id", values: chatIds)
            .order("created_at", ascending: false)
            .execute()
            .value
        
        return chats
    }
    
    //Getting participants for chat
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
    
    //Deleting a chat
    func deleteChat(chatId: UUID) async throws {
        try await supabase
            .from("chats")
            .delete()
            .eq("id", value: chatId.uuidString)
            .execute()
    }
}
