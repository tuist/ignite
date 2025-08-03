import SwiftUI
import WebKit

struct RemoteSimulatorView: View {
    @EnvironmentObject var appState: AppState
    @State private var chatText = ""
    @State private var showBottomSheet = false
    @FocusState private var isChatFocused: Bool
    
    var body: some View {
        ZStack {
            // Full screen web view
            WebView(url: appState.currentURL)
                .ignoresSafeArea()
            
            // Floating chat bar at bottom
            VStack {
                Spacer()
                
                ChatBar(
                    text: $chatText,
                    isFocused: $isChatFocused,
                    showBottomSheet: $showBottomSheet,
                    onSend: sendMessage
                )
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
        .sheet(isPresented: $showBottomSheet) {
            BottomSheetView()
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }
    
    private func sendMessage() {
        guard !chatText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        // TODO: Send message to server
        print("Sending message: \(chatText)")
        
        // Clear the text field
        chatText = ""
    }
}

// WebView wrapper
struct WebView: UIViewRepresentable {
    let url: String
    
    func makeUIView(context: Context) -> WKWebView {
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.scrollView.contentInsetAdjustmentBehavior = .never
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let url = URL(string: url) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

// Chat bar component
struct ChatBar: View {
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    @Binding var showBottomSheet: Bool
    let onSend: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Text field with background
            HStack {
                TextField("Type a message...", text: $text)
                    .textFieldStyle(.plain)
                    .focused(isFocused)
                    .onSubmit {
                        onSend()
                    }
                
                // Send button
                Button(action: onSend) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.blue)
                }
                .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
            .cornerRadius(25)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            
            // Options button
            Button {
                showBottomSheet = true
            } label: {
                Image(systemName: "ellipsis.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.gray)
                    .background(Color(.systemBackground))
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            }
        }
    }
}