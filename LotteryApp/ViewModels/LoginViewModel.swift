import Foundation
import SwiftUI

@MainActor
class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    
    func login() async {
        errorMessage = nil
        
        if let emailError = ValidationUtils.getEmailError(email) {
            errorMessage = emailError
            return
        }
        
        if password.isEmpty {
            errorMessage = "Введите пароль"
            return
        }
        
        isLoading = true
        
        do {
            let request = LoginRequest(email: email, password: password)
            let response = try await AuthService.shared.login(request)
            
            TokenManager.shared.saveToken(response.token)
            TokenManager.shared.saveUser(response.user)
            
            isAuthenticated = true
        } catch ApiError.unauthorized {
            errorMessage = "Неверный email или пароль"
        } catch ApiError.networkError(let error) {
            errorMessage = "Ошибка сети: \(error.localizedDescription)"
        } catch {
            errorMessage = "Ошибка входа: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

