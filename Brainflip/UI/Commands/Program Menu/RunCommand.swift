import SwiftUI

struct RunCommand: View {
    @FocusedObject<ProgramState> var state
    
    var body: some View {
        Button("Run") {
            state?.run()
        }
        .keyboardShortcut("r")
        .disabled(state?.disableRunButton ?? true)
        .accessibilityIdentifier("runProgram:")
    }
}
