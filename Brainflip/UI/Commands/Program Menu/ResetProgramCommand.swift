import SwiftUI

struct ResetProgramCommand: View {
    @FocusedObject<ProgramState> var state
    
    var body: some View {
        Button("Reset Program") {
            state?.reset()
        }
        .disabled(state?.disableResetButton ?? true)
    }
}
