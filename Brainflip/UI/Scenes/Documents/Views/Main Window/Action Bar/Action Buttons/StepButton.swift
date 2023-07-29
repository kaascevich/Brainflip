import SwiftUI

struct StepButton: View {
    @EnvironmentObject private var settings: AppSettings
    @Environment(ProgramState.self) var state: ProgramState
    
    @State private var symbolEffect = false
    
    var body: some View {
        Button {
            symbolEffect.toggle()
            state.step()
        } label: {
            Label("Step Through", systemImage: "arrowshape.bounce.forward")
                .symbolVariant(.fill)
                .symbolEffect(.bounce.down, value: symbolEffect)
        }
        .buttonStyle(.bordered)
        .disabled(state.disableStepButton)
    }
}

#Preview {
    StepButton()
        .environmentObject(settings)
        .environment(previewState)
}
