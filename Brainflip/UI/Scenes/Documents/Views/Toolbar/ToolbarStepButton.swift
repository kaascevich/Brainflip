import SwiftUI

struct ToolbarStepButton: ToolbarContent {
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
                state.step()
            } label: {
                Label("Step Through", systemImage: "arrowshape.bounce.forward.fill")
            }
            .disabled(state.disableStepButton)
        }
    }
}
