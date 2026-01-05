import Foundation
import Supabase

class SupabaseService {
    static let shared = SupabaseService()
    
    private let supabase: SupabaseClient
    
    private init() {
        // Replace with your actual Supabase credentials
        let supabaseURL = URL(string: "https://dytlriqwrsyytnwjnmzp.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR5dGxyaXF3cnN5eXRud2pubXpwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY0ODkxMzgsImV4cCI6MjA4MjA2NTEzOH0.GyrUjaI_m5rs020nNLquoX_RoUU0KuNBTFSoPJK28PY"
        
        supabase = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
        print("✅ Supabase client initialized")
    }
    
    // MARK: - Donation History Methods
    
    /// Fetch donations by user ID
    func fetchDonationHistory(forUserId userId: String) async throws -> [DonationHistory] {
        print("🌐 Fetching donations for user ID: '\(userId)'")
        
        let response = try await supabase
            .from("Donation_history")
            .select("""
                *,
                donor:User!donor_id(id, first_name, last_name, email, profile_image_url)
            """)
            .eq("donor_id", value: userId)
            .order("date", ascending: false)
            .execute()
        
        let donations = try JSONDecoder().decode([DonationHistory].self, from: response.data)
        print("✅ Fetched \(donations.count) donations")
        
        return donations
    }
    
    /// Fetch all donations (test mode - no filter)
    func fetchAllDonations() async throws -> [DonationHistory] {
        print("🌐 Fetching ALL donations (test mode)")
        
        let response = try await supabase
            .from("Donation_history")
            .select("""
                *,
                donor:User!donor_id(id, first_name, last_name, email, profile_image_url)
            """)
            .order("date", ascending: false)
            .limit(10)
            .execute()
        
        let donations = try JSONDecoder().decode([DonationHistory].self, from: response.data)
        print("✅ Fetched \(donations.count) donations (all users)")
        
        return donations
    }
    
    // MARK: - Donation Detail Method
    
    /// Fetch single donation with all details including feedback
    func fetchDonationDetail(forDonationId donationId: Int) async throws -> DonationDetail {
        print("🌐 Fetching donation detail for ID: \(donationId)")
        
        let response = try await supabase
            .from("Donation_history")
            .select("""
                *,
                donor:User!donor_id(id, first_name, last_name, email, phone_number, profile_image_url),
                collector:User!collector_id(id, first_name, last_name, email, phone_number),
                DonerFeedback(*),
                collectorFeedback(*)
            """)
            .eq("donationid", value: donationId)
            .single()
            .execute()
        
        let detail = try JSONDecoder().decode(DonationDetail.self, from: response.data)
        print("✅ Fetched donation detail")
        
        return detail
    }
    
    // MARK: - Helper Methods
    
    /// Get user ID by email (test helper)
    func getUserIdByEmail(_ email: String) async throws -> String {
        print("🔍 Looking up user ID for: '\(email)'")
        
        let response = try await supabase
            .from("User")
            .select("id")
            .eq("email", value: email)
            .single()
            .execute()
        
        struct UserIdResponse: Codable {
            let id: String
        }
        
        let user = try JSONDecoder().decode(UserIdResponse.self, from: response.data)
        print("✅ Found user ID: \(user.id)")
        
        return user.id
    }
}
