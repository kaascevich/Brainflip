import SwiftUI

struct ClearAllButton: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some View {
        Button("Clear All...", role: .destructive) {
            state.isClearAlertShowing.toggle()
        }
        .disabled(state.isRunningProgram)
    }
}

#Preview {
    ClearAllButton(state: previewState)
        .environmentObject(settings)
}
