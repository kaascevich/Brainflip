import SwiftUI

struct ClearInputButton: View {
    @EnvironmentObject private var settings: AppSettings
    @Environment(\.appState) private var state: AppState
    
    var body: some View {
        Button("Clear Input") {
            state.input = ""
        }
        .disabled(state.input.isEmpty || state.isRunningProgram)
    }
}

#Preview {
    ClearInputButton()
        .environmentObject(settings)
        .environment(previewState)
}
