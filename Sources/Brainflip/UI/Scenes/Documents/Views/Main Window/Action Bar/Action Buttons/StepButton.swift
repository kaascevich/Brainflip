import SwiftUI

struct StepButton: View {
    @EnvironmentObject private var settings: AppSettings
    @Environment(AppState.self) private var state: AppState
    
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
        .accessibilityIdentifier("step-button-main")
    }
}

#Preview {
    StepButton()
        .environmentObject(settings)
        .environment(previewState)
}
