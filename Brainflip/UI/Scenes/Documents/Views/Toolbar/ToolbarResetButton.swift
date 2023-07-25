import SwiftUI

struct ToolbarResetButton: ToolbarContent {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    @State private var symbolEffect = false
    
    var body: some ToolbarContent {
        ToolbarItem {
            Button {
                symbolEffect.toggle()
                state.reset()
            } label: {
                Label("Reset", systemImage: "arrow.triangle.2.circlepath")
                    .symbolVariant(.circle)
                    .symbolEffect(.bounce, value: symbolEffect)
            }
            .disabled(state.disableResetButton)
        }
    }
}
