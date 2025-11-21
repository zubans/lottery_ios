import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        Group {
            if appState.isAuthenticated {
                HomeView()
            } else {
                LoginView()
            }
        }
        .onAppear {
            appState.checkAuthentication()
        }
    }
}

