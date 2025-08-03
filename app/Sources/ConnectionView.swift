import SwiftUI

struct ConnectionView: View {
    @EnvironmentObject var appState: AppState
    @State private var urlInput = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 20) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.orange.gradient)
                
                Text("Ignite")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Connect to your development server")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
            .padding(.top, 60)
            .padding(.bottom, 40)
            
            // URL Input Section
            VStack(spacing: 16) {
                HStack {
                    TextField("Enter server URL", text: $urlInput)
                        .textFieldStyle(.plain)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.URL)
                        .focused($isTextFieldFocused)
                        .onSubmit {
                            connectToServer()
                        }
                    
                    Button("Connect") {
                        connectToServer()
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(urlInput.isEmpty)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                // Recent URLs
                if !appState.recentURLs.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recent URLs")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 4)
                        
                        ForEach(appState.recentURLs, id: \.self) { url in
                            Button {
                                urlInput = url
                                connectToServer()
                            } label: {
                                HStack {
                                    Image(systemName: "clock.arrow.circlepath")
                                        .foregroundStyle(.secondary)
                                    
                                    Text(url)
                                        .foregroundStyle(.primary)
                                        .lineLimit(1)
                                    
                                    Spacer()
                                    
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.tertiary)
                                        .font(.caption)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .onAppear {
            // Pre-fill with the most recent URL if available
            if let mostRecent = appState.recentURLs.first {
                urlInput = mostRecent
            }
        }
    }
    
    private func connectToServer() {
        guard !urlInput.isEmpty else { return }
        
        // Ensure URL has a scheme
        var finalURL = urlInput.trimmingCharacters(in: .whitespacesAndNewlines)
        if !finalURL.hasPrefix("http://") && !finalURL.hasPrefix("https://") {
            finalURL = "http://\(finalURL)"
        }
        
        appState.connect(to: finalURL)
    }
}