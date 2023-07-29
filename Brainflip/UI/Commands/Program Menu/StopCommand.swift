import SwiftUI

struct StopCommand: View {
    @FocusedValue(\.appState) private var state
    
    var body: some View {
        Button("Stop") {
            state?.stop()
        }
        .keyboardShortcut(".")
        .disabled(state == nil || state!.disableStopButton)
        .accessibilityIdentifier("stopRunningProgram:")
    }
}
