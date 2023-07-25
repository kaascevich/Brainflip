import SwiftUI

struct ToolbarStepButton: ToolbarContent {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
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
