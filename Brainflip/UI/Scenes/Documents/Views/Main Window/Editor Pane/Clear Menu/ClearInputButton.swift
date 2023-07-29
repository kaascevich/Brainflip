import SwiftUI

struct ClearInputButton: View {
    @EnvironmentObject private var settings: AppSettings
    @Environment(ProgramState.self) var state: ProgramState
    
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
        .environmentObject(previewState)
}
