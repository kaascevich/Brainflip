import SwiftUI

struct HighlightingToggle: View {
    @EnvironmentObject private var settings: AppSettings
    @State private var turningOnHighlighting = AppSettings().highlighting
    @State private var isWarningAboutHighlighting = false
    
    var body: some View {
        Toggle("Enable syntax highlighting", isOn: $turningOnHighlighting)
            .alert("Enable syntax highlighting?", isPresented: $isWarningAboutHighlighting) {
                Button("Enable") {
                    settings.highlighting = true
                }
                Button("Cancel", role: .cancel) {
                    settings.highlighting = false
                    turningOnHighlighting = false
                }
            } message: {
                Text("Enabling syntax highlighting will cause significant slowdown with larger files.")
            }
            .onChange(of: turningOnHighlighting) {
                if turningOnHighlighting {
                    isWarningAboutHighlighting.toggle()
                } else {
                    settings.highlighting = false
                }
            }
    }
}

#Preview {
    HighlightingToggle()
}
