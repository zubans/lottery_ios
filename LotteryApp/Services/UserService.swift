import Foundation

class UserService {
    static let shared = UserService()
    
    private init() {}
    
    func getProfile() async throws -> User {
        return try await ApiService.shared.request(
            endpoint: "/profile",
            method: "GET"
        )
    }
    
    func updateProfile(_ request: UpdateProfileRequest) async throws -> User {
        return try await ApiService.shared.request(
            endpoint: "/profile",
            method: "PUT",
            body: request
        )
    }
    
    func getTransactions() async throws -> [Transaction] {
        return try await ApiService.shared.request(
            endpoint: "/transactions",
            method: "GET"
        )
    }
    
    func deposit(_ request: DepositRequest) async throws -> User {
        return try await ApiService.shared.request(
            endpoint: "/transactions/deposit",
            method: "POST",
            body: request
        )
    }
}

