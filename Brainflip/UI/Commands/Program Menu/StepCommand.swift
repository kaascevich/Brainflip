import SwiftUI

struct StepCommand: View {
    @FocusedObject<ProgramState> var state
    
    var body: some View {
        Button("Step Through") {
            state?.step()
        }
        .keyboardShortcut("r", modifiers: [.command, .shift])
        .buttonRepeatBehavior(.enabled)
        .disabled(state?.disableStepButton ?? true)
    }
}
