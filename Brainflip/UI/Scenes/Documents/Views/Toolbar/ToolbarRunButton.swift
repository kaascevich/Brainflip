import SwiftUI

struct ToolbarRunButton: ToolbarContent {
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
                state.run()
            } label: {
                Label("Run", systemImage: "play.fill")
            }
            .disabled(state.disableRunButton)
        }
    }
}
