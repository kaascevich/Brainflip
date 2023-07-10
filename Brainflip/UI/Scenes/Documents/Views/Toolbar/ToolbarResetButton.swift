import SwiftUI

struct ToolbarResetButton: ToolbarContent {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    let placement: ToolbarItemPlacement
    init(state: ProgramState, placement: ToolbarItemPlacement) {
        self.state = state
        self.placement = placement
    }
    
    var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            Button {
                state.reset()
            } label: {
                Label("Reset", systemImage: "arrow.triangle.2.circlepath.circle")
            }
            .disabled(state.disableResetButton)
        }
    }
}
