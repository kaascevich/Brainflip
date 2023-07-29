import SwiftUI

struct ResetProgramCommand: View {
    @FocusedValue(\.programState) private var state
    
    var body: some View {
        Button("Reset Program") {
            state?.reset()
        }
        .keyboardShortcut(".", modifiers: [.shift, .command])
        .disabled(state == nil || state!.disableResetButton || state!.disableMenuItems)
        .accessibilityIdentifier("resetProgramState:")
    }
}
