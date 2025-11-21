import Foundation
import SwiftUI

@MainActor
class RegisterViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var middleName = ""
    @Published var agreedToTerms = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isRegistered = false
    
    func register() async {
        errorMessage = nil
        
        if firstName.isEmpty || lastName.isEmpty {
            errorMessage = "Заполните все обязательные поля"
            return
        }
        
        if let emailError = ValidationUtils.getEmailError(email) {
            errorMessage = emailError
            return
        }
        
        if let passwordError = ValidationUtils.getPasswordError(password) {
            errorMessage = passwordError
            return
        }
        
        if !agreedToTerms {
            errorMessage = "Необходимо принять лицензионное соглашение"
            return
        }
        
        isLoading = true
        
        do {
            let request = RegisterRequest(
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName,
                middleName: middleName.isEmpty ? nil : middleName
            )
            
            let response = try await AuthService.shared.register(request)
            
            TokenManager.shared.saveToken(response.token)
            TokenManager.shared.saveUser(response.user)
            
            isRegistered = true
        } catch ApiError.serverError(let code, let message) where code == 409 {
            errorMessage = "Email уже зарегистрирован"
        } catch ApiError.networkError(let error) {
            errorMessage = "Ошибка сети: \(error.localizedDescription)"
        } catch {
            errorMessage = "Ошибка регистрации: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

