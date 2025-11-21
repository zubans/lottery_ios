import Foundation

class GameService {
    static let shared = GameService()
    
    private init() {}
    
    func getCurrentGame() async throws -> GameStatusResponse {
        return try await ApiService.shared.request(
            endpoint: "/game/current",
            method: "GET"
        )
    }
    
    func participate() async throws -> ParticipateResponse {
        return try await ApiService.shared.request(
            endpoint: "/game/participate",
            method: "POST"
        )
    }
}

