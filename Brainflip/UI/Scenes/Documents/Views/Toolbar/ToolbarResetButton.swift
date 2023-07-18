import SwiftUI

struct ToolbarResetButton: ToolbarContent {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    init(state: ProgramState) {
        self.state = state
    }
    
    var body: some ToolbarContent {
        ToolbarItem {
            Button {
                state.reset()
            } label: {
                Label("Reset", systemImage: "arrow.triangle.2.circlepath.circle")
            }
            .disabled(state.disableResetButton)
        }
    }
}
