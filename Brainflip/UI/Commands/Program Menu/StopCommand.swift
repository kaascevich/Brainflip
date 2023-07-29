import SwiftUI

struct StopCommand: View {
    @FocusedObject<ProgramState> var state
    
    var body: some View {
        Button("Stop") {
            state?.stop()
        }
        .keyboardShortcut(".")
        .disabled(state == nil || state!.disableStopButton)
        .accessibilityIdentifier("stopRunningProgram:")
    }
}
