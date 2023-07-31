import SwiftUI

struct ToolbarStepButton: ToolbarContent {
    @EnvironmentObject private var settings: AppSettings
    @Environment(\.appState) private var state: AppState
    
    @State private var symbolEffect = false
    
    var body: some ToolbarContent {
        ToolbarItem {
            Button {
                symbolEffect.toggle()
                state.step()
            } label: {
                Label("Step Through", systemImage: "arrowshape.bounce.forward")
                    .symbolVariant(.fill)
                    .symbolEffect(.bounce.down, value: symbolEffect)
            }
            .buttonRepeatBehavior(.enabled)
            .disabled(state.disableStepButton)
        }
    }
}
