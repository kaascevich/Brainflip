import SwiftUI

struct ShowArrayCommand: View {
    @FocusedObject<ProgramState> var state
    
    var body: some View {
        Button("Show Array") {
            state?.showingArray.toggle()
        }
        .disabled(state?.disableResetButton ?? true)
    }
}
