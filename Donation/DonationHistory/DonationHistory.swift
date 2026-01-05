import Foundation

// MARK: - Donation History (List item)
struct DonationHistory: Codable {
    let donationid: Int
    let donorId: String
    let collectorId: String?
    let email: String?
    let date: String?
    let status: String?
    let user: String?
    
    // Nested donor info from JOIN
    let donor: DonorUser?
    
    enum CodingKeys: String, CodingKey {
        case donationid
        case donorId = "donor_id"        
        case collectorId = "collector_id"
        case email
        case date
        case status
        case user
        case donor
    }
}
