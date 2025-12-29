//
//  SupabaseManager.swift
//  Donation
//
//  Created by Claude
//

import Foundation
import UIKit
import Supabase

class SupabaseManager {
    
    // MARK: - Singleton
    static let shared = SupabaseManager()
    
    // MARK: - Properties
    private let client: SupabaseClient
    
    // MARK: - Initialization
    private init() {
        guard let url = URL(string: SupabaseConfig.supabaseURL) else {
            fatalError("Invalid Supabase URL")
        }
        
        self.client = SupabaseClient(
            supabaseURL: url,
            supabaseKey: SupabaseConfig.supabaseAnonKey
        )
    }
    
    // MARK: - User Operations
    
    /// Fetch all users from Supabase
    func fetchUsers() async throws -> [User] {
        let response: [User] = try await client
            .from(SupabaseConfig.Tables.users)
            .select()
            .order("createdAt", ascending: false)
            .execute()
            .value
        
        return response
    }
    
    /// Fetch a single user by ID
    func fetchUser(id: String) async throws -> User {
        let response: [User] = try await client
            .from(SupabaseConfig.Tables.users)
            .select()
            .eq("id", value: id)
            .execute()
            .value
        
        guard let user = response.first else {
            throw SupabaseError.userNotFound
        }
        
        return user
    }
    
    /// Search users by name or email
    func searchUsers(query: String) async throws -> [User] {
        let response: [User] = try await client
            .from(SupabaseConfig.Tables.users)
            .select()
            .or("firstName.ilike.%\(query)%,lastName.ilike.%\(query)%,email.ilike.%\(query)%")
            .execute()
            .value
        
        return response
    }
    
    /// Create a new user
    func createUser(_ user: User) async throws -> User {
        let response: User = try await client
            .from(SupabaseConfig.Tables.users)
            .insert(user)
            .select()
            .single()
            .execute()
            .value
        
        return response
    }
    
    /// Update an existing user
    func updateUser(_ user: User) async throws -> User {
        let response: User = try await client
            .from(SupabaseConfig.Tables.users)
            .update(user)
            .eq("id", value: user.id)
            .select()
            .single()
            .execute()
            .value
        
        return response
    }
    
    /// Delete a user
    func deleteUser(id: String) async throws {
        try await client
            .from(SupabaseConfig.Tables.users)
            .delete()
            .eq("id", value: id)
            .execute()
    }
    
    /// Toggle user active status
    func toggleUserStatus(id: String, isActive: Bool) async throws -> User {
        let response: User = try await client
            .from(SupabaseConfig.Tables.users)
            .update(["isActive": isActive])
            .eq("id", value: id)
            .select()
            .single()
            .execute()
            .value
        
        return response
    }
    
    // MARK: - Report Operations
    
    /// Fetch all reports
    func fetchReports() async throws -> [Report] {
        let response: [Report] = try await client
            .from(SupabaseConfig.Tables.reports)
            .select()
            .order("createdAt", ascending: false)
            .execute()
            .value
        
        return response
    }
    
    /// Fetch reports by status
    func fetchReports(status: Report.ReportStatus) async throws -> [Report] {
        let response: [Report] = try await client
            .from(SupabaseConfig.Tables.reports)
            .select()
            .eq("status", value: status.rawValue)
            .order("createdAt", ascending: false)
            .execute()
            .value
        
        return response
    }
    
    /// Create a new report
    func createReport(_ report: Report) async throws -> Report {
        let response: Report = try await client
            .from(SupabaseConfig.Tables.reports)
            .insert(report)
            .select()
            .single()
            .execute()
            .value
        
        return response
    }
    
    /// Update report status
    func updateReportStatus(id: String, status: Report.ReportStatus) async throws -> Report {
        let response: Report = try await client
            .from(SupabaseConfig.Tables.reports)
            .update(["status": status.rawValue])
            .eq("id", value: id)
            .select()
            .single()
            .execute()
            .value
        
        return response
    }
    
    /// Delete a report
    func deleteReport(id: String) async throws {
        try await client
            .from(SupabaseConfig.Tables.reports)
            .delete()
            .eq("id", value: id)
            .execute()
    }
    
    // MARK: - Storage Operations
    
    /// Upload profile image to Supabase Storage
    func uploadProfileImage(_ image: UIImage, userId: String) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw SupabaseError.imageConversionFailed
        }
        
        let fileName = "\(userId)_\(UUID().uuidString).jpg"
        let filePath = "\(SupabaseConfig.Buckets.profileImages)/\(fileName)"
        
        let uploadResponse = try await client.storage
            .from(SupabaseConfig.Buckets.profileImages)
            .upload(
                path: fileName,
                file: imageData,
                options: FileOptions(contentType: "image/jpeg")
            )
        
        // Get public URL
        let publicURL = try client.storage
            .from(SupabaseConfig.Buckets.profileImages)
            .getPublicURL(path: fileName)
        
        return publicURL.absoluteString
    }
    
    /// Delete profile image from Supabase Storage
    func deleteProfileImage(url: String) async throws {
        // Extract file path from URL
        guard let urlComponents = URLComponents(string: url),
              let pathComponents = urlComponents.path.split(separator: "/").last else {
            return
        }
        
        let fileName = String(pathComponents)
        
        try await client.storage
            .from(SupabaseConfig.Buckets.profileImages)
            .remove(paths: [fileName])
    }
    
    // MARK: - Authentication (Optional)
    
    /// Sign up a new user
    func signUp(email: String, password: String) async throws {
        try await client.auth.signUp(email: email, password: password)
    }
    
    /// Sign in an existing user
    func signIn(email: String, password: String) async throws {
        try await client.auth.signIn(email: email, password: password)
    }
    
    /// Sign out current user
    func signOut() async throws {
        try await client.auth.signOut()
    }
    
    /// Get current session
    func getCurrentSession() async throws -> Session {
        try await client.auth.session
    }
}

// MARK: - Custom Errors
enum SupabaseError: LocalizedError {
    case userNotFound
    case reportNotFound
    case imageConversionFailed
    case uploadFailed
    case deleteFailed
    
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "User not found"
        case .reportNotFound:
            return "Report not found"
        case .imageConversionFailed:
            return "Failed to convert image"
        case .uploadFailed:
            return "Failed to upload file"
        case .deleteFailed:
            return "Failed to delete item"
        }
    }
}
