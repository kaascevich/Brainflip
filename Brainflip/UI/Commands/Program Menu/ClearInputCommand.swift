import SwiftUI

struct ClearInputCommand: View {
    @FocusedValue(\.programState) private var state
    
    var body: some View {
        Button("Clear Input") {
            state?.input = ""
        }
        .keyboardShortcut(.delete, modifiers: [.option, .shift, .command])
        .disabled(state == nil || state!.input.isEmpty || state!.disableMenuItems)
        .accessibilityIdentifier("clearProgramInput:")
    }
}
