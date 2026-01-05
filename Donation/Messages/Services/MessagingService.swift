import Foundation
import Supabase

class MessagingService {
    var messages: [Message] = []
    private let supabase = SupabaseService.shared.client
    private var pollingTimer: Timer?
    
    var onMessagesUpdated: (([Message]) -> Void)?
    
    // MARK: - Helper Structs for Encoding
    private struct MessageInsert: Encodable {
        let chat_id: String
        let sender_id: String
        let receiver_id: String
        let text: String
        let image_url: String?
        
        init(chatId: UUID, senderId: UUID, receiverId: UUID, text: String, imageUrl: String? = nil) {
            self.chat_id = chatId.uuidString
            self.sender_id = senderId.uuidString
            self.receiver_id = receiverId.uuidString
            self.text = text
            self.image_url = imageUrl
        }
    }
    
    private struct MessageUpdate: Encodable {
        let read_at: String
    }
    
    func sendMessage(text: String, chatId: UUID, senderId: UUID, receiverId: UUID) async throws {
        let newMessage = MessageInsert(
            chatId: chatId,
            senderId: senderId,
            receiverId: receiverId,
            text: text
        )
        
        try await supabase
            .from("messages")
            .insert(newMessage)
            .execute()
        
        try? await fetchMessages(chatId: chatId)
    }
    
    func sendMessageWithImage(text: String, imageUrl: String, chatId: UUID, senderId: UUID, receiverId: UUID) async throws {
        let newMessage = MessageInsert(
            chatId: chatId,
            senderId: senderId,
            receiverId: receiverId,
            text: text,
            imageUrl: imageUrl
        )
        
        try await supabase
            .from("messages")
            .insert(newMessage)
            .execute()
        
        try? await fetchMessages(chatId: chatId)
    }
    
    func fetchMessages(chatId: UUID) async throws {
        let response: [Message] = try await supabase
            .from("messages")
            .select()
            .eq("chat_id", value: chatId.uuidString)
            .order("created_at")
            .execute()
            .value
        
        self.messages = response
        
        DispatchQueue.main.async {
            self.onMessagesUpdated?(response)
        }
    }
    
    func subscribeToMessages(chatId: UUID) {
        Task {
            try? await fetchMessages(chatId: chatId)
        }
        
        pollingTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            Task {
                try? await self?.fetchMessages(chatId: chatId)
            }
        }
    }
    
    func unsubscribe() {
        pollingTimer?.invalidate()
        pollingTimer = nil
    }
    
    func markAsRead(messageId: UUID) async throws {
        let update = MessageUpdate(
            read_at: ISO8601DateFormatter().string(from: Date())
        )
        
        try await supabase
            .from("messages")
            .update(update)
            .eq("id", value: messageId.uuidString)
            .execute()
    }
}
