import Foundation

struct User: Codable {
    let id: Int
    let email: String
    let firstName: String
    let lastName: String
    let middleName: String?
    let balance: Double
    let locked: Bool
    let telegramNick: String?
    let createdAt: String
    let updatedAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case middleName = "middle_name"
        case balance
        case locked
        case telegramNick = "telegram_nick"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    var isVerified: Bool {
        return telegramNick != nil && !telegramNick!.isEmpty
    }
}

