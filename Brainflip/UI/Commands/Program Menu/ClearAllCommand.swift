import SwiftUI

struct ClearAllCommand: View {
    @FocusedValue(\.programState) private var state
    
    var body: some View {
        Button("Clear All...") {
            state?.isClearAlertShowing.toggle()
        }
        .keyboardShortcut(.delete, modifiers: [.shift, .command])
        .disabled(state == nil || state!.disableMenuItems)
        .accessibilityIdentifier("clearAllDocumentContents:")
    }
}
