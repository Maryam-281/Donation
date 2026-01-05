import Foundation

// MARK: - Donation Detail (Full donation with relationships)
struct DonationDetail: Codable {
    let donationid: Int
    let donorId: String
    let collectorId: String?
    let email: String?
    let date: String?
    let status: String?
    let user: String?
    
    // Nested relationships from JOINs
    let donor: DonorUser?
    let collector: CollectorUser?
    let donerFeedback: [DonerFeedback]?
    let collectorFeedback: [CollectorFeedback]?
    
    enum CodingKeys: String, CodingKey {
        case donationid
        case donorId = "donor_id"
        case collectorId = "collector_id"
        case email
        case date
        case status
        case user
        case donor
        case collector
        case donerFeedback = "DonerFeedback"
        case collectorFeedback
    }
}

// MARK: - Donor User Info
struct DonorUser: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String?
    let profileImageUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneNumber = "phone_number"
        case profileImageUrl = "profile_image_url"
    }
}

// MARK: - Collector User Info
struct CollectorUser: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneNumber = "phone_number"
    }
}

// MARK: - Donor Feedback
struct DonerFeedback: Codable {
    let donerFeedId: Int
    let pickupTime: Int          // Maps to "pickupTime" (camelCase in DB)
    let donerComments: String?   // Maps to "DonerComments" (PascalCase in DB)
    let donationid: Int
    
    enum CodingKeys: String, CodingKey {
        case donerFeedId = "donerFeedId"
        case pickupTime = "pickupTime"        // ✅ Exact DB column name
        case donerComments = "DonerComments"  // ✅ Exact DB column name (capital D, capital C)
        case donationid
    }
}

// MARK: - Collector Feedback
struct CollectorFeedback: Codable {
    let collectFeedbcakId: Int
    let packagingRate: Int       // Maps to "packagingRate" (camelCase in DB)
    let hygieneRate: Int?        // Maps to "hygieneRate" (camelCase in DB)
    let collectorComments: String?  // Maps to "collectorComments" (camelCase in DB)
    let donationid: Int
    
    enum CodingKeys: String, CodingKey {
        case collectFeedbcakId = "collectFeedbcakId"
        case packagingRate = "packagingRate"          // ✅ Exact DB column name
        case hygieneRate = "hygieneRate"              // ✅ Exact DB column name
        case collectorComments = "collectorComments"  // ✅ Exact DB column name (camelCase)
        case donationid
    }
}
