import SwiftUI

struct ShowArrayCommand: View {
    @FocusedValue(\.programState) private var state
    
    var body: some View {
        Button("Show Array") {
            state?.showingArray.toggle()
        }
        .disabled(state == nil || state!.disableResetButton || state!.disableMenuItems)
        .accessibilityIdentifier("revealProgramArray:")
    }
}
