import SwiftUI

struct StepButton: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    @State private var symbolEffect = false
    
    var body: some View {
        Button {
            symbolEffect.toggle()
            state.step()
        } label: {
            Label("Step Through", systemImage: "arrowshape.bounce.forward")
                .symbolVariant(.fill)
                .symbolEffect(.bounce, value: symbolEffect)
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
