import SwiftUI

struct StopCommand: View {
    @FocusedObject<ProgramState> var state
    
    var body: some View {
        Button("Stop") {
            state?.stop()
        }
        .keyboardShortcut(.escape)
        .disabled(state?.disableStopButton ?? true)
    }
}
