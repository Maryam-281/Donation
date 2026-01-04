import Foundation
import Supabase

class UserService {
    private let supabase = SupabaseService.shared.client
    
    func getUser(id: UUID) async throws -> User {
        let user: User = try await supabase
            .from("User")
            .select()
            .eq("id", value: id.uuidString)
            .single()
            .execute()
            .value
        
        return user
    }
    
    func getUserByEmail(email: String) async throws -> User? {
        let users: [User] = try await supabase
            .from("User")
            .select()
            .eq("email", value: email)
            .limit(1)
            .execute()
            .value
        
        return users.first
    }
    
    func getUsers(ids: [UUID]) async throws -> [User] {
        let users: [User] = try await supabase
            .from("User")
            .select()
            .in("id", values: ids.map { $0.uuidString })
            .execute()
            .value
        
        return users
    }
    
    func updateProfileImage(userId: UUID, imageUrl: String) async throws {
        let update: [String: String] = [
            "profile_image_url": imageUrl
        ]
        
        let _: EmptyResponse = try await supabase
            .from("User")
            .update(update)
            .eq("id", value: userId.uuidString)
            .execute()
            .value
    }
}

struct EmptyResponse: Decodable {}
