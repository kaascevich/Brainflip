import SwiftUI

struct TrimCommand: View {
    @FocusedObject<ProgramState> var state
    
    var body: some View {
        Button("Trim") {
            state?.isWarningAboutTrim.toggle()
        }
        .disabled(state == nil || state!.disableMenuItems)
        .accessibilityIdentifier("trimProgram:")
    }
}
