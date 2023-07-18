import SwiftUI

struct ToolbarPanelToggles: ToolbarContent {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    init(state: ProgramState) {
        self.state = state
    }
    
    var body: some ToolbarContent {
        ToolbarItemGroup {
            Toggle(isOn: $state.isShowingOutput) {
                Label(state.isShowingOutput ? "Hide Output" : "Show Output", systemImage: "square.bottomthird.inset.filled")
            }
            Toggle(isOn: $state.isShowingInspector) {
                Label(state.isShowingInspector ? "Hide Inspector" : "Show Inspector", systemImage: "square.trailingthird.inset.filled")
            }
        }
     }
}
