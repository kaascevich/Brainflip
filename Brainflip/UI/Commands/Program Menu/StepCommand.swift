import SwiftUI

struct StepCommand: View {
    @FocusedValue(\.programState) private var state
    
    var body: some View {
        Button("Step Through") {
            state?.step()
        }
        .keyboardShortcut("r", modifiers: [.command, .shift])
        .disabled(state == nil || state!.disableStepButton || state!.disableMenuItems)
        .accessibilityIdentifier("stepThroughProgram:")
    }
}
