import Foundation

class AuthService {
    static let shared = AuthService()
    
    private init() {}
    
    func register(_ request: RegisterRequest) async throws -> LoginResponse {
        return try await ApiService.shared.request(
            endpoint: "/register",
            method: "POST",
            body: request
        )
    }
    
    func login(_ request: LoginRequest) async throws -> LoginResponse {
        return try await ApiService.shared.request(
            endpoint: "/login",
            method: "POST",
            body: request
        )
    }
}

