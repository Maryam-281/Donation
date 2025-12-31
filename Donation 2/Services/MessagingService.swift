//
//  MessagingService.swift
//  Donation
//
//  Created by BP-36-201-19 on 31/12/2025.
//

import Foundation
import Supabase

class MessagingService {
    var messages: [Message] = []
    private let supabase = SupabaseManager.shared.client
    private var realtimeChannel: RealtimeChannelV2?
    
    //Callback as to when the messages update
    var onMessagesUpdated: (([Message]) -> Void)?
    
    //Send a message
    func sendMessage(text: String, chatId: UUID, senderId: UUID) async throws {
        let newMessage: [String: Any] = [
            "chat_id": chatId.uuidString,
            "sender_id": senderId.uuidString,
            "text": text
        ]
        
        try await supabase
            .from("messages")
            .insert(newMessage)
            .execute()
    }
    
    //Fetching messages for a chat
    func fetchMessages(chatId: UUID) async throws {
        let response: [Message] = try await supabase
            .from("messages")
            .select()
            .eq( "chat_id", value: chatId.uuidString)
            .order("created_at", ascending: true)
            .value
        
        self.messages = response
        
        //Notify on main thread
        DispatchQueue.main.async {
            self.onMessagesUpdated?(response)
        }
    }
    
    //Subscribing to real-time updates
    func subscribeToMessages(chatId: UUID){
        realtimeChannel = supabase.realtimeV2.channel("messages-\(chatId)")
        
        let messageInserts = realtimeChannel!.postgresChange(
            InsertAction.self,
            schema: "public",
            table: "messages",
            filter: "chat_id=eq.\(chatId)"
        )
        
        Task {
            for await insert in messageInserts {
                if let newMessage = try? insert.decodeRecord(as: Message.self){
                    DispatchQueue.main.async {
                        self.messages.append(newMessage)
                        self.onMessagesUpdated?(self.messages)
                    }
                }
            }
        }
        
        Task {
            await realtimeChannel?.subscribe()
        }
    }
    
    //Unsubscribe when leaving chat
    func unsubscribe() {
        Task {
            await realtimeChannel?.unsubscribe()
        }
        realtimeChannel = nil
    }
    
    //Mark messages as read
    func markAsRead(messageId: UUID) async throws {
        let update: [String: Any] = [
            "read_at": ISO8601DateFormatter().string(from: Date())
        ]
        
        try await supabase
            .from("messages")
            .update(update)
            .eq("id", value: messageId.uuidString)
            .execute()
    }
    
}
