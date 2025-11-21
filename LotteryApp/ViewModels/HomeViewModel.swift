import Foundation
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var gameStatus: GameStatusResponse?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var participateResult: ParticipateResponse?
    @Published var isWinner = false
    @Published var isNewGame = false
    
    private var statusTimer: Timer?
    private var syncTimer: Timer?
    private var serverTime: Date?
    private var timeRemaining: Int64 = 0
    
    @Published var currentTimeRemaining: Int64 = 0
    
    func loadGameStatus() async {
        do {
            let status = try await GameService.shared.getCurrentGame()
            self.gameStatus = status
            
            if let serverTimeStr = status.serverTime {
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
                serverTime = formatter.date(from: serverTimeStr) ?? Date()
                timeRemaining = status.timeRemaining
                currentTimeRemaining = status.timeRemaining
            }
        } catch {
            errorMessage = "Ошибка загрузки статуса игры"
        }
    }
    
    func participate() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await GameService.shared.participate()
            self.participateResult = result
            self.isWinner = result.isWinner
            self.isNewGame = result.isNewGame
            
            await loadGameStatus()
            
            if let user = TokenManager.shared.getUser() {
                let updatedUser = try await UserService.shared.getProfile()
                TokenManager.shared.saveUser(updatedUser)
            }
        } catch ApiError.paymentRequired {
            errorMessage = "Недостаточно средств на счете. Для участия необходимо пополнить баланс на 1 рубль."
        } catch ApiError.networkError(let error) {
            errorMessage = "Ошибка сети: \(error.localizedDescription)"
        } catch {
            errorMessage = "Ошибка участия в игре: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func startTimers() {
        statusTimer = Timer.scheduledTimer(withTimeInterval: Constants.statusUpdateInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                await self?.loadGameStatus()
            }
        }
        
        syncTimer = Timer.scheduledTimer(withTimeInterval: Constants.fullSyncInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                await self?.loadGameStatus()
            }
        }
        
        Timer.scheduledTimer(withTimeInterval: Constants.timerUpdateInterval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.updateTimer()
            }
        }
    }
    
    func stopTimers() {
        statusTimer?.invalidate()
        syncTimer?.invalidate()
    }
    
    private func updateTimer() {
        guard let serverTime = serverTime, timeRemaining > 0 else {
            currentTimeRemaining = 0
            return
        }
        
        let elapsed = Int64(Date().timeIntervalSince(serverTime))
        let remaining = max(0, timeRemaining - elapsed)
        currentTimeRemaining = remaining
        
        if remaining <= 0 {
            Task {
                await loadGameStatus()
            }
        }
    }
    
    func formatTime(_ seconds: Int64) -> String {
        let mins = seconds / 60
        let secs = seconds % 60
        return String(format: "%02d:%02d", mins, secs)
    }
}

