import SwiftUI

struct HideInspectorCommand: View {
    @FocusedObject<ProgramState> var state
    
    var body: some View {
        Button((state?.isShowingInspector ?? false) ? "Hide Inspector" : "Show Inspector") {
            state?.isShowingInspector.toggle()
        }
        .disabled(state == nil)
    }
}
