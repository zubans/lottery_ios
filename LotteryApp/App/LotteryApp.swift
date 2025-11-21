import SwiftUI

@main
struct LotteryApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}

class AppState: ObservableObject {
    @Published var isAuthenticated: Bool
    
    init() {
        self.isAuthenticated = TokenManager.shared.isAuthenticated
    }
    
    func checkAuthentication() {
        isAuthenticated = TokenManager.shared.isAuthenticated
    }
}

