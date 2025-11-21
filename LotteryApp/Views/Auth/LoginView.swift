import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var showRegister = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Лотерея")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 40)
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Email")
                        .font(.headline)
                    TextField("Введите email", text: $viewModel.email)
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Пароль")
                        .font(.headline)
                    SecureField("Введите пароль", text: $viewModel.password)
                        .textFieldStyle(.roundedBorder)
                }
                
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                }
                
                Button(action: {
                    Task {
                        await viewModel.login()
                    }
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    } else {
                        Text("Войти")
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                    }
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isLoading)
                
                HStack {
                    Text("Нет аккаунта?")
                    Button("Зарегистрироваться") {
                        showRegister = true
                    }
                }
                .font(.subheadline)
            }
            .padding()
            .navigationDestination(isPresented: $viewModel.isAuthenticated) {
                HomeView()
            }
            .sheet(isPresented: $showRegister) {
                RegisterView()
            }
        }
    }
}

