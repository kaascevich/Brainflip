import SwiftUI

struct HideOutputCommand: View {
    @FocusedValue(\.programState) private var state
    
    var body: some View {
        Button((state?.isShowingOutput ?? false) ? "Hide Output" : "Show Output") {
            state?.isShowingOutput.toggle()
        }
        .disabled(state == nil)
        .accessibilityIdentifier("showOutputPane:")
    }
}
