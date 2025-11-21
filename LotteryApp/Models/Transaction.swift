import Foundation

struct Transaction: Codable {
    let id: Int
    let userId: Int
    let type: String
    let amount: Double
    let description: String?
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case type
        case amount
        case description
        case createdAt = "created_at"
    }
}

struct DepositRequest: Codable {
    let amount: Double
}

