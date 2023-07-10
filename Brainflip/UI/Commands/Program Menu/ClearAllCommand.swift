import SwiftUI

struct ClearAllCommand: View {
    @FocusedObject<ProgramState> var state
    
    var body: some View {
        Button("Clear All...") {
            state?.isClearAlertShowing.toggle()
        }
        .keyboardShortcut(.delete)
        .disabled(state?.document.contents.isEmpty ?? true)
    }
}
