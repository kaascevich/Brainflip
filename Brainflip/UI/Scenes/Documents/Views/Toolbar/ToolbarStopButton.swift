import SwiftUI

struct ToolbarStopButton: ToolbarContent {
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
                state.stop()
            } label: {
                Label("Stop", systemImage: "octagon.fill")
            }
            .disabled(state.disableStopButton)
        }
     }
}
