import SwiftUI

struct ToolbarRunButton: ToolbarContent {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
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
