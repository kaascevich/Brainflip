import SwiftUI

struct ToolbarStopButton: ToolbarContent {
    @EnvironmentObject private var settings: AppSettings
    @Environment(AppState.self) private var state: AppState
    
    @State private var symbolEffect = false
    
    var body: some ToolbarContent {
        ToolbarItem {
            Button {
                symbolEffect.toggle()
                state.stop()
            } label: {
                Label("Stop", systemImage: "octagon")
                    .symbolVariant(.fill)
                    .symbolEffect(.bounce.down, value: symbolEffect)
            }
            .disabled(state.disableStopButton)
        }
     }
}
