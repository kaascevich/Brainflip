import SwiftUI

struct HideOutputCommand: View {
    @FocusedObject<ProgramState> var state
    
    var body: some View {
        Button((state?.isShowingOutput ?? false) ? "Hide Output" : "Show Output") {
            state?.isShowingOutput.toggle()
        }
        .disabled(state == nil)
        .accessibilityIdentifier("showOutputPane:")
    }
}
