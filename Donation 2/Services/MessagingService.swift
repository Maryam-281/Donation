import Foundation
import Supabase

class MessagingService {
    var messages: [Message] = []
    private let supabase = SupabaseManager.shared.client
    private var realtimeChannel: RealtimeChannelV2?
    private var currentChatId: UUID?
    
    // Callback for when messages update
    var onMessagesUpdated: (([Message]) -> Void)?
    
    // Send a message
    func sendMessage(text: String, chatId: UUID, senderId: UUID) async throws {
        let newMessage: [String: String] = [
            "chat_id": chatId.uuidString,
            "sender_id": senderId.uuidString,
            "text": text
        ]
        
        struct EmptyResponse: Codable {}
        let _: [EmptyResponse] = try await supabase
            .from("messages")
            .insert(newMessage)
            .execute()
            .value
    }
    
    // Fetch messages for a chat
    func fetchMessages(chatId: UUID) async throws {
        // Custom decoder for dates
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let response: [Message] = try await supabase
            .from("messages")
            .select()
            .eq("chat_id", value: chatId.uuidString)
            .order("created_at")
            .execute()
            .value
        
        self.messages = response
        
        // Notify on main thread
        await MainActor.run {
            self.onMessagesUpdated?(response)
        }
    }
    
    // Subscribe to real-time updates
    func subscribeToMessages(chatId: UUID) {
        self.currentChatId = chatId
        let channelId = "messages-\(chatId.uuidString)"
        realtimeChannel = supabase.realtimeV2.channel(channelId)
        
        Task {
            // Subscribe to INSERT changes on messages table
            let changes = await realtimeChannel!.postgresChange(
                InsertAction.self,
                schema: "public",
                table: "messages",
                filter: "chat_id=eq.\(chatId.uuidString)"
            )
            
            await realtimeChannel?.subscribe()
            
            // Listen for changes
            for await _ in changes {
                handleNewMessage()
            }
        }
    }
    
    // Handle new message inserts
    private func handleNewMessage() {
        // When we get a new insert, just refetch all messages
        guard let chatId = currentChatId else { return }
        
        Task {
            try? await fetchMessages(chatId: chatId)
        }
    }
    
    // Unsubscribe when leaving chat
    func unsubscribe() {
        Task {
            await realtimeChannel?.unsubscribe()
        }
        realtimeChannel = nil
        currentChatId = nil
    }
    
    // Mark message as read
    func markAsRead(messageId: UUID) async throws {
        let update: [String: String] = [
            "read_at": ISO8601DateFormatter().string(from: Date())
        ]
        
        struct EmptyResponse: Codable {}
        let _: [EmptyResponse] = try await supabase
            .from("messages")
            .update(update)
            .eq("id", value: messageId.uuidString)
            .execute()
            .value
    }
}
