import SwiftUI

struct ResetProgramCommand: View {
    @FocusedObject<ProgramState> var state
    
    var body: some View {
        Button("Reset Program") {
            state?.reset()
        }
        .keyboardShortcut(".", modifiers: [.shift, .command])
        .disabled(state == nil || state!.disableResetButton || state!.isConversionProgressShowing)
        .accessibilityIdentifier("resetProgramState:")
    }
}
