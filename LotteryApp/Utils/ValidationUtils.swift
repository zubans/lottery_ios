import Foundation

struct ValidationUtils {
    private static let emailRegex = #"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"#
    
    static func isValidEmail(_ email: String) -> Bool {
        if email.isEmpty { return false }
        let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return predicate.evaluate(with: email)
    }
    
    static func isValidPassword(_ password: String) -> Bool {
        if password.count < Constants.minPasswordLength {
            return false
        }
        
        let hasLetter = password.rangeOfCharacter(from: .letters) != nil
        let hasDigit = password.rangeOfCharacter(from: .decimalDigits) != nil
        
        return hasLetter && hasDigit
    }
    
    static func getEmailError(_ email: String) -> String? {
        if email.isEmpty {
            return "Email не может быть пустым"
        }
        if !isValidEmail(email) {
            return "Введите корректный email адрес"
        }
        return nil
    }
    
    static func getPasswordError(_ password: String) -> String? {
        if password.isEmpty {
            return "Пароль не может быть пустым"
        }
        if password.count < Constants.minPasswordLength {
            return "Пароль должен содержать не менее 6 символов"
        }
        if password.rangeOfCharacter(from: .letters) == nil {
            return "Пароль должен содержать буквы"
        }
        if password.rangeOfCharacter(from: .decimalDigits) == nil {
            return "Пароль должен содержать цифры"
        }
        return nil
    }
}

