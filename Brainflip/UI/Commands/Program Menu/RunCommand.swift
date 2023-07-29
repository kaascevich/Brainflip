import SwiftUI

struct RunCommand: View {
    @FocusedValue(\.programState) private var state
    
    var body: some View {
        Button("Run") {
            state?.run()
        }
        .keyboardShortcut("r")
        .disabled(state == nil || state!.disableRunButton || state!.disableMenuItems)
        .accessibilityIdentifier("runProgram:")
    }
}
