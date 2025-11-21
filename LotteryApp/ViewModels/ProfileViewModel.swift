import Foundation
import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: User?
    @Published var transactions: [Transaction] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isLoggedOut = false
    
    func loadProfile() async {
        isLoading = true
        
        do {
            let profile = try await UserService.shared.getProfile()
            self.user = profile
            TokenManager.shared.saveUser(profile)
        } catch ApiError.unauthorized {
            logout()
        } catch {
            errorMessage = "Ошибка загрузки профиля"
        }
        
        isLoading = false
    }
    
    func loadTransactions() async {
        do {
            self.transactions = try await UserService.shared.getTransactions()
        } catch {
            errorMessage = "Ошибка загрузки транзакций"
        }
    }
    
    func updateProfile(firstName: String, lastName: String, middleName: String?) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let request = UpdateProfileRequest(
                firstName: firstName,
                lastName: lastName,
                middleName: middleName
            )
            let updatedUser = try await UserService.shared.updateProfile(request)
            self.user = updatedUser
            TokenManager.shared.saveUser(updatedUser)
        } catch {
            errorMessage = "Ошибка обновления профиля"
        }
        
        isLoading = false
    }
    
    func logout() {
        TokenManager.shared.deleteToken()
        TokenManager.shared.deleteUser()
        isLoggedOut = true
    }
}

