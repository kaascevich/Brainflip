import SwiftUI

struct ToolbarResetButton: ToolbarContent {
    @EnvironmentObject private var settings: AppSettings
    @Environment(\.appState) private var state: AppState
    
    @State private var symbolEffect = false
    
    var body: some ToolbarContent {
        ToolbarItem {
            Button {
                symbolEffect.toggle()
                state.reset()
            } label: {
                Label("Reset", systemImage: "arrow.triangle.2.circlepath")
                    .symbolVariant(.circle)
                    .symbolEffect(.bounce.down, value: symbolEffect)
            }
            .disabled(state.disableResetButton)
        }
    }
}
