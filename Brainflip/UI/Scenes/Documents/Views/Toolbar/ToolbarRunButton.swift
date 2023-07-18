import SwiftUI

struct ToolbarRunButton: ToolbarContent {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    init(state: ProgramState) {
        self.state = state
    }
    
    var body: some ToolbarContent {
        ToolbarItem {
            Button {
                state.run()
            } label: {
                Label("Run", systemImage: "play.fill")
            }
            .disabled(state.disableRunButton)
        }
    }
}
