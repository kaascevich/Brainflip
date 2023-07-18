import SwiftUI

struct ToolbarOutputToggle: ToolbarContent {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    init(state: ProgramState) {
        self.state = state
    }
    
    var body: some ToolbarContent {
        ToolbarItem {
            Toggle(isOn: $state.isShowingOutput) {
                Label(state.isShowingOutput ? "Hide Output" : "Show Output", systemImage: "rectangle.bottomthird.inset.filled")
            }
        }
     }
}
