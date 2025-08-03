import SwiftUI

struct BottomSheetView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    // Connection info
                    HStack {
                        Label("Connected to", systemImage: "link.circle.fill")
                            .foregroundStyle(.green)
                        Spacer()
                        Text(appState.currentURL)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    
                    // Disconnect button
                    Button {
                        dismiss()
                        appState.disconnect()
                    } label: {
                        Label("Disconnect", systemImage: "xmark.circle")
                            .foregroundStyle(.red)
                    }
                } header: {
                    Text("Connection")
                }
                
                Section {
                    Button {
                        // TODO: Implement refresh
                        dismiss()
                    } label: {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                    
                    Button {
                        // TODO: Implement clear chat
                        dismiss()
                    } label: {
                        Label("Clear Chat", systemImage: "trash")
                    }
                } header: {
                    Text("Actions")
                }
                
                Section {
                    Link(destination: URL(string: "https://ignite.tuist.dev")!) {
                        Label("Documentation", systemImage: "book")
                    }
                    
                    Link(destination: URL(string: "https://github.com/tuist/ignite/issues")!) {
                        Label("Report Issue", systemImage: "exclamationmark.triangle")
                    }
                } header: {
                    Text("Help")
                }
                
                Section {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }
                } footer: {
                    Text("Ignite is free software licensed under MPL-2.0")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top)
                }
            }
            .navigationTitle("Options")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}