import Foundation

struct User: Codable, Identifiable {
    let id: UUID
    let firstName: String
    let lastName: String
    let email: String
    let birthDate: Date?
    let phoneNumber: String?
    let profileImageUrl: String?
    let isActive: Bool
    let createdAt: Date?
    
    var fullName: String {
        "\(firstName) \(lastName)"
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case birthDate = "birth_date"
        case phoneNumber = "phone_number"
        case profileImageUrl = "profile_image_url"
        case isActive = "is_active"
        case createdAt = "created_at"
    }
}
