//
//  User.swift
//  Donation
//
//  Created by Claude
//

import Foundation

struct User: Codable, Identifiable {
    let id: String
    var firstName: String
    var lastName: String
    var email: String
    var birthDate: String?  // ISO 8601 date string for Supabase
    var phoneNumber: String?
    var password: String?  // Optional for updates (won't be returned from DB)
    var profileImageURL: String?
    var isActive: Bool
    var createdAt: String  // ISO 8601 datetime string for Supabase
    
    // Coding keys to match Supabase column names
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case birthDate = "birth_date"
        case phoneNumber = "phone_number"
        case password
        case profileImageURL = "profile_image_url"
        case isActive = "is_active"
        case createdAt = "created_at"
    }
    
    init(id: String = UUID().uuidString,
         firstName: String,
         lastName: String,
         email: String,
         birthDate: Date? = nil,
         phoneNumber: String? = nil,
         password: String? = nil,
         profileImageURL: String? = nil,
         isActive: Bool = true,
         createdAt: Date = Date()) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.birthDate = birthDate?.iso8601String
        self.phoneNumber = phoneNumber
        self.password = password
        self.profileImageURL = profileImageURL
        self.isActive = isActive
        self.createdAt = createdAt.iso8601String
    }
    
    // Computed properties
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
    
    var birthDateAsDate: Date? {
        guard let birthDate = birthDate else { return nil }
        return Date.fromISO8601(birthDate)
    }
    
    var createdAtAsDate: Date {
        return Date.fromISO8601(createdAt) ?? Date()
    }
}

// MARK: - Date Extensions for Supabase
extension Date {
    var iso8601String: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: self)
    }
    
    static func fromISO8601(_ string: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = formatter.date(from: string) {
            return date
        }
        // Try without fractional seconds
        formatter.formatOptions = [.withInternetDateTime]
        return formatter.date(from: string)
    }
}
