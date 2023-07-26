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
                .symbolEffect(.bounce.down, value: symbolEffect)
        }
        .buttonStyle(.bordered)
        .disabled(state.disableStepButton)
    }
}

#Preview {
    StepButton(state: previewState)
        .environmentObject(settings)
}
