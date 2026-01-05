
import Foundation

struct Report: Codable, Identifiable {
    let id: String
    let reportedUserId: String
    let reportedUserName: String
    let reporterUserId: String
    let reason: String
    let description: String
    let createdAt: String  // ISO 8601 datetime string for Supabase
    var status: String  // Store as String for Supabase
    
    // Coding keys to match Supabase column names
    enum CodingKeys: String, CodingKey {
        case id
        case reportedUserId = "reported_user_id"
        case reportedUserName = "reported_user_name"
        case reporterUserId = "reporter_user_id"
        case reason
        case description
        case createdAt = "created_at"
        case status
    }
    
    enum ReportStatus: String, Codable, CaseIterable {
        case pending = "Pending"
        case reviewed = "Reviewed"
        case resolved = "Resolved"
        case dismissed = "Dismissed"
    }
    
    init(id: String = UUID().uuidString,
         reportedUserId: String,
         reportedUserName: String,
         reporterUserId: String,
         reason: String,
         description: String,
         createdAt: Date = Date(),
         status: ReportStatus = .pending) {
        self.id = id
        self.reportedUserId = reportedUserId
        self.reportedUserName = reportedUserName
        self.reporterUserId = reporterUserId
        self.reason = reason
        self.description = description
        self.createdAt = createdAt.iso8601String
        self.status = status.rawValue
    }
    
    // Computed property for typed status
    var reportStatus: ReportStatus {
        return ReportStatus(rawValue: status) ?? .pending
    }
    
    var createdAtAsDate: Date {
        return Date.fromISO8601(createdAt) ?? Date()
    }
}
