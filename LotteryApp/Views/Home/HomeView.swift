import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showRules = false
    @State private var showParticipateResult = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    Text("Лотерея")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    if let status = viewModel.gameStatus {
                        VStack(spacing: 16) {
                            Text("Участников: \(status.minParticipants)-\(status.maxParticipants)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                            
                            Text("Приз: \(String(format: "%.2f", status.game.prizeAmount)) ₽")
                                .font(.title3)
                                .foregroundColor(.green)
                            
                            Text("Стоимость участия: 1 ₽")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                            
                            if viewModel.currentTimeRemaining > 0 {
                                VStack(spacing: 4) {
                                    Text("Осталось времени:")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text(viewModel.formatTime(viewModel.currentTimeRemaining))
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.red)
                                }
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            } else {
                                Text("Время истекло")
                                    .font(.headline)
                                    .foregroundColor(.red)
                            }
                            
                            if let message = status.proximityMessage {
                                Text(message)
                                    .font(.headline)
                                    .foregroundColor(.orange)
                            }
                            
                            if status.userTicketsCount > 0 {
                                Text("Ваших билетов в этой игре: \(status.userTicketsCount)")
                                    .font(.subheadline)
                                    .foregroundColor(.purple)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 4)
                    }
                    
                    Button(action: {
                        Task {
                            await viewModel.participate()
                            showParticipateResult = true
                        }
                    }) {
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                        } else {
                            Text("Участвовать")
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(viewModel.isLoading || viewModel.currentTimeRemaining <= 0)
                    
                    Button("Правила игры") {
                        showRules = true
                    }
                    .buttonStyle(.bordered)
                    
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding()
                    }
                }
                .padding()
            }
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: ProfileView()) {
                        Image(systemName: "person.circle")
                    }
                }
            }
            .sheet(isPresented: $showRules) {
                RulesView()
            }
            .alert("Результат", isPresented: $showParticipateResult) {
                Button("OK") {
                    if viewModel.isWinner {
                        // Можно добавить confetti анимацию
                    }
                }
            } message: {
                if viewModel.isWinner {
                    Text("🎉 Поздравляем! Вы победитель!")
                } else if viewModel.isNewGame {
                    Text("Началась новая игра!")
                } else {
                    Text("Вы успешно приняли участие в игре")
                }
            }
            .task {
                await viewModel.loadGameStatus()
                viewModel.startTimers()
            }
            .onDisappear {
                viewModel.stopTimers()
            }
        }
    }
}

