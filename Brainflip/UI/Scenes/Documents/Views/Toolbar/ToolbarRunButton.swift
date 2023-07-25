import SwiftUI

struct ToolbarRunButton: ToolbarContent {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    @State private var symbolEffect = false
    
    var body: some ToolbarContent {
        ToolbarItem {
            Button {
                symbolEffect.toggle()
                state.run()
            } label: {
                Label("Run", systemImage: "play")
                    .symbolVariant(.fill)
                    .symbolEffect(.bounce.down, value: symbolEffect)
            }
            .disabled(state.disableRunButton)
        }
    }
}
