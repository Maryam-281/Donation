// SupabaseService.swift
import Foundation
import Supabase

class SupabaseService {
    static let shared = SupabaseService()
    
    private let client: SupabaseClient
    
    private init() {
        // Replace with your Supabase credentials
        let supabaseURL = URL(string: "https://dytlriqwrsyytnwjnmzp.supabase.co")!
        let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR5dGxyaXF3cnN5eXRud2pubXpwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY0ODkxMzgsImV4cCI6MjA4MjA2NTEzOH0.GyrUjaI_m5rs020nNLquoX_RoUU0KuNBTFSoPJK28PY"
        
        client = SupabaseClient(supabaseURL: supabaseURL, supabaseKey: supabaseKey)
        
        print("✅ Supabase client initialized")
    }
    
    // MARK: - Fetch Donation History
    func fetchDonationHistory(forEmail email: String) async throws -> [DonationHistory] {
        print("🌐 Supabase: Fetching donations for email: '\(email)'")
        
        let response: [DonationHistory] = try await client
            .from("Donation_history")
            .select()
            .eq("email", value: email)
            .order("date", ascending: false)
            .execute()
            .value
        
        print("🌐 Supabase: Response count: \(response.count)")
        
        return response
    }
    
    // Fetch all donations (for admin view)
    func fetchAllDonationHistory() async throws -> [DonationHistory] {
        print("🌐 Starting fetchAllDonationHistory")
        
        do {
            let response: [DonationHistory] = try await client
                .from("Donation_history")
                .select()
                .order("date", ascending: false)
                .execute()
                .value
            
            print("🌐 Success! Got \(response.count) rows")
            print("🌐 Raw response: \(response)")
            
            return response
        } catch {
            print("❌ Fetch error: \(error)")
            print("❌ Error type: \(type(of: error))")
            print("❌ Error description: \(error.localizedDescription)")
            throw error
        }
    }
    
    // MARK: - Fetch Donor Feedback
    func fetchDonerFeedback(forDonationId donationId: Int) async throws -> DonerFeedback? {
        let response: [DonerFeedback] = try await client
            .from("DonerFeedback")
            .select()
            .eq("donationid", value: donationId)
            .execute()
            .value
        
        return response.first
    }
    
    // MARK: - Fetch Collector Feedback
    func fetchCollectorFeedback(forDonationId donationId: Int) async throws -> CollectorFeedback? {
        let response: [CollectorFeedback] = try await client
            .from("collectorFeedback")
            .select()
            .eq("donationid", value: donationId)
            .execute()
            .value
        
        return response.first
    }
    
    // MARK: - Fetch Complete Donation Detail
    func fetchDonationDetail(forDonationId donationId: Int) async throws -> DonationDetail {
        // Fetch donation
        let donations: [DonationHistory] = try await client
            .from("Donation_history")
            .select()
            .eq("donationid", value: donationId)
            .execute()
            .value
        
        guard let donation = donations.first else {
            throw NSError(domain: "SupabaseService", code: 404,
                         userInfo: [NSLocalizedDescriptionKey: "Donation not found"])
        }
        
        // Fetch feedbacks concurrently
        async let donerFeedbackTask = fetchDonerFeedback(forDonationId: donationId)
        async let collectorFeedbackTask = fetchCollectorFeedback(forDonationId: donationId)
        
        let (doner, collector) = try await (donerFeedbackTask, collectorFeedbackTask)
        
        return DonationDetail(
            donation: donation,
            donerFeedback: doner,
            collectorFeedback: collector
        )
    }
    
    // MARK: - Create New Donation
    func createDonation(email: String, date: String, status: String, user: String) async throws -> DonationHistory {
        // Create a struct that matches the insert format
        struct NewDonation: Encodable {
            let email: String
            let date: String
            let status: String
            let user: String
        }
        
        let newDonation = NewDonation(
            email: email,
            date: date,
            status: status,
            user: user
        )
        
        let response: DonationHistory = try await client
            .from("Donation_history")
            .insert(newDonation)
            .select()
            .single()
            .execute()
            .value
        
        return response
    }
    
    // MARK: - Update Donation Status
    func updateDonationStatus(donationId: Int, status: String) async throws {
        try await client
            .from("Donation_history")
            .update(["status": status])
            .eq("donationid", value: donationId)
            .execute()
    }
}
