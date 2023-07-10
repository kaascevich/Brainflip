import SwiftUI

struct ClearInputCommand: View {
    @FocusedObject<ProgramState> var state
    
    var body: some View {
        Button("Clear Input") {
            state?.input = ""
        }
        .disabled(state?.input.isEmpty ?? true)
    }
}
