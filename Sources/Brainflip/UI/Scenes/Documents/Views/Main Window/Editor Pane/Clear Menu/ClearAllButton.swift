import SwiftUI

struct ClearAllButton: View {
    @EnvironmentObject private var settings: AppSettings
    @Environment(AppState.self) private var state: AppState
    
    var body: some View {
        Button("Clear All…", role: .destructive) {
            state.isClearAlertShowing.toggle()
        }
        .disabled(state.isRunningProgram || state.isLocked)
    }
}

#Preview {
    ClearAllButton()
        .environmentObject(settings)
        .environment(previewState)
}
