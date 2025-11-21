import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showTransactions = false
    
    var body: some View {
        NavigationStack {
            List {
                if let user = viewModel.user {
                    Section("Личная информация") {
                        HStack {
                            Text("Email:")
                            Spacer()
                            Text(user.email)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Имя:")
                            Spacer()
                            Text(user.firstName)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Фамилия:")
                            Spacer()
                            Text(user.lastName)
                                .foregroundColor(.secondary)
                        }
                        
                        if let middleName = user.middleName, !middleName.isEmpty {
                            HStack {
                                Text("Отчество:")
                                Spacer()
                                Text(middleName)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        if let telegramNick = user.telegramNick {
                            HStack {
                                Text("Telegram:")
                                Spacer()
                                Text("@\(telegramNick)")
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                    
                    Section("Баланс") {
                        HStack {
                            Text("Текущий баланс:")
                            Spacer()
                            Text("\(String(format: "%.2f", user.balance)) ₽")
                                .fontWeight(.bold)
                                .foregroundColor(.green)
                        }
                        
                        Button(action: {
                            if let url = URL(string: Constants.telegramGroupURL) {
                                UIApplication.shared.open(url)
                            }
                        }) {
                            HStack {
                                Image(systemName: "paperplane.fill")
                                Text("Пополнить счет")
                            }
                            .foregroundColor(.blue)
                        }
                        .disabled(!user.isVerified)
                        .opacity(user.isVerified ? 1.0 : 0.5)
                        
                        if !user.isVerified {
                            Text("Для пополнения необходимо верифицировать аккаунт через Telegram")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                    }
                    
                    Section("Действия") {
                        Button(action: {
                            showTransactions = true
                        }) {
                            HStack {
                                Image(systemName: "list.bullet")
                                Text("Транзакции")
                            }
                        }
                        
                        Button(role: .destructive, action: {
                            viewModel.logout()
                        }) {
                            HStack {
                                Image(systemName: "arrow.right.square")
                                Text("Выйти")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Профиль")
            .sheet(isPresented: $showTransactions) {
                TransactionsView()
            }
            .navigationDestination(isPresented: $viewModel.isLoggedOut) {
                LoginView()
            }
            .task {
                await viewModel.loadProfile()
            }
            .refreshable {
                await viewModel.loadProfile()
            }
        }
    }
}

