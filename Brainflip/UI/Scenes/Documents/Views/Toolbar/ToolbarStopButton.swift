import SwiftUI

struct ToolbarStopButton: ToolbarContent {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    init(state: ProgramState) {
        self.state = state
    }
    
    var body: some ToolbarContent {
        ToolbarItem {
            Button {
                state.stop()
            } label: {
                Label("Stop", systemImage: "octagon.fill")
            }
            .disabled(state.disableStopButton)
        }
     }
}
