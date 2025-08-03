import SwiftUI

struct ContentView: View {
    @StateObject private var appState = AppState()
    
    var body: some View {
        Group {
            if appState.isConnected {
                RemoteSimulatorView()
            } else {
                ConnectionView()
            }
        }
        .environmentObject(appState)
        .animation(.easeInOut(duration: 0.3), value: appState.isConnected)
    }
}

#Preview {
    ContentView()
}