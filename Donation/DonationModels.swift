// DonationModels.swift
import Foundation
import UIKit

// MARK: - Donation History Model
struct DonationHistory: Codable, Identifiable {
    let donationid: Int
    let email: String
    let date: String?
    let status: String?
    let user: String?
    
    var id: Int { donationid }
    
    enum CodingKeys: String, CodingKey {
        case donationid
        case email
        case date
        case status
        case user
    }
    
    // Helper computed properties
    var formattedDate: String {
        guard let dateString = date else { return "N/A" }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        
        if let date = formatter.date(from: dateString) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            return displayFormatter.string(from: date)
        }
        return dateString
    }
    
    var statusColor: UIColor {
        switch status?.lowercased() {
        case "completed":
            return .systemGreen
        case "pending":
            return .systemOrange
        case "cancelled":
            return .systemRed
        default:
            return .systemGray
        }
    }
}

// MARK: - Donor Feedback Model
struct DonerFeedback: Codable, Identifiable {
    let donerFeedId: Int
    let pickupTime: Int
    let DonerComments: String?
    let donationid: Int?
    
    var id: Int { donerFeedId }
    
    enum CodingKeys: String, CodingKey {
        case donerFeedId
        case pickupTime
        case DonerComments
        case donationid
    }
}

// MARK: - Collector Feedback Model
struct CollectorFeedback: Codable, Identifiable {
    let collectFeedbcakId: Int
    let packagingRate: Int
    let hygieneRate: Int?
    let donationid: Int?
    let collectorComments: String?
    
    var id: Int { collectFeedbcakId }
    
    enum CodingKeys: String, CodingKey {
        case collectFeedbcakId
        case packagingRate
        case hygieneRate
        case donationid
        case collectorComments
    }
}

// MARK: - Combined Donation Detail (for detailed view)
struct DonationDetail {
    let donation: DonationHistory
    var donerFeedback: DonerFeedback?
    var collectorFeedback: CollectorFeedback?
}
