import SwiftUI

struct ClearAllButton: View {
    @EnvironmentObject private var settings: AppSettings
    @Environment(ProgramState.self) private var state: ProgramState
    
    var body: some View {
        Button("Clear All...", role: .destructive) {
            state.isClearAlertShowing.toggle()
        }
        .disabled(state.isRunningProgram)
    }
}

#Preview {
    ClearAllButton()
        .environmentObject(settings)
        .environment(previewState)
}
