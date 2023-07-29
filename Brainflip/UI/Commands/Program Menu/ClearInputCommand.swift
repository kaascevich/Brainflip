import SwiftUI

struct ClearInputCommand: View {
    @FocusedObject<ProgramState> var state
    
    var body: some View {
        Button("Clear Input") {
            state?.input = ""
        }
        .keyboardShortcut(.delete, modifiers: [.option, .shift, .command])
        .disabled(state == nil || state!.input.isEmpty || state!.disableMenuItems)
        .accessibilityIdentifier("clearProgramInput:")
    }
}
