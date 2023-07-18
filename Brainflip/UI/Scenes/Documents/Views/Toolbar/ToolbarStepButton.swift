import SwiftUI

struct ToolbarStepButton: ToolbarContent {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    init(state: ProgramState) {
        self.state = state
    }
    
    var body: some ToolbarContent {
        ToolbarItem {
            Button {
                state.step()
            } label: {
                Label("Step Through", systemImage: "arrowshape.bounce.forward.fill")
            }
            .disabled(state.disableStepButton)
        }
    }
}
