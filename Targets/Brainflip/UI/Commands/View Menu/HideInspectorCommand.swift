import SwiftUI

struct HideInspectorCommand: View {
    @FocusedValue(\.appState) private var state
    
    var body: some View {
        Button((state?.isShowingInspector ?? false) ? "Hide Inspector" : "Show Inspector") {
            state?.isShowingInspector.toggle()
        }
        .disabled(state == nil)
        .accessibilityIdentifier("showInspectorPane:")
    }
}
