import SwiftUI

struct StepButton: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some View {
        Button {
            state.step()
        } label: {
            Label("Step Through", systemImage: "arrowshape.bounce.forward.fill")
        }
        .buttonRepeatBehavior(.enabled)
        .buttonStyle(.bordered)
        .disabled(state.disableStepButton)
    }
}

#Preview {
    StepButton(state: previewState)
        .environmentObject(settings)
}
