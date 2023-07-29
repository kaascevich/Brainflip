import SwiftUI

struct StepCommand: View {
    @FocusedObject<ProgramState> var state
    
    var body: some View {
        Button("Step Through") {
            state?.step()
        }
        .keyboardShortcut("r", modifiers: [.command, .shift])
        .disabled(state == nil || state!.disableStepButton || state!.isConversionProgressShowing)
        .accessibilityIdentifier("stepThroughProgram:")
    }
}
