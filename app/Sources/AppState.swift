import SwiftUI
import Combine

@MainActor
class AppState: ObservableObject {
    @Published var isConnected = false
    @Published var currentURL = ""
    @Published var recentURLs: [String] = []
    
    private let recentURLsKey = "recentURLs"
    private let maxRecentURLs = 5
    
    init() {
        loadRecentURLs()
    }
    
    func connect(to url: String) {
        currentURL = url
        isConnected = true
        addToRecentURLs(url)
    }
    
    func disconnect() {
        isConnected = false
    }
    
    private func loadRecentURLs() {
        if let urls = UserDefaults.standard.stringArray(forKey: recentURLsKey) {
            recentURLs = urls
        } else {
            // Default URL for local development
            recentURLs = ["http://localhost:4000"]
        }
    }
    
    private func addToRecentURLs(_ url: String) {
        // Remove if already exists
        recentURLs.removeAll { $0 == url }
        // Add to beginning
        recentURLs.insert(url, at: 0)
        // Keep only max number of URLs
        if recentURLs.count > maxRecentURLs {
            recentURLs = Array(recentURLs.prefix(maxRecentURLs))
        }
        // Save to UserDefaults
        UserDefaults.standard.set(recentURLs, forKey: recentURLsKey)
    }
}