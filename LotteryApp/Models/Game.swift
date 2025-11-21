import Foundation

struct Game: Codable {
    let id: Int
    let status: String
    let winnerId: Int?
    let prizeAmount: Double
    let startTime: String?
    let endTime: String?
    let createdAt: String
    let endedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case status
        case winnerId = "winner_id"
        case prizeAmount = "prize_amount"
        case startTime = "start_time"
        case endTime = "end_time"
        case createdAt = "created_at"
        case endedAt = "ended_at"
    }
}

struct GameStatusResponse: Codable {
    let game: Game
    let participants: Int
    let isWinner: Bool
    let minParticipants: Int
    let maxParticipants: Int
    let proximityMessage: String?
    let userTicketsCount: Int
    let timeRemaining: Int64
    let serverTime: String?
    
    enum CodingKeys: String, CodingKey {
        case game
        case participants
        case isWinner = "is_winner"
        case minParticipants = "min_participants"
        case maxParticipants = "max_participants"
        case proximityMessage = "proximity_message"
        case userTicketsCount = "user_tickets_count"
        case timeRemaining = "time_remaining"
        case serverTime = "server_time"
    }
}

struct ParticipateResponse: Codable {
    let game: Game
    let participants: Int
    let isWinner: Bool
    let isNewGame: Bool
    let proximityMessage: String?
    let userTicketsCount: Int
    
    enum CodingKeys: String, CodingKey {
        case game
        case participants
        case isWinner = "is_winner"
        case isNewGame = "is_new_game"
        case proximityMessage = "proximity_message"
        case userTicketsCount = "user_tickets_count"
    }
}

