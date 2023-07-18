import SwiftUI

struct ClearAllCommand: View {
    @FocusedObject<ProgramState> var state
    
    var body: some View {
        Button("Clear All...") {
            state?.isClearAlertShowing.toggle()
        }
        .keyboardShortcut(.delete, modifiers: [.shift, .command])
        .disabled(state == nil)
    }
}
