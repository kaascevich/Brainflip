import SwiftUI

struct ToolbarPanelToggles: ToolbarContent {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some ToolbarContent {
        ToolbarItemGroup {
            Toggle(isOn: $state.isShowingOutput) {
                Label(state.isShowingOutput ? "Hide Output" : "Show Output", systemImage: "square.bottomthird.inset.filled")
                    .symbolEffect(.bounce, value: state.isShowingOutput)
            }
            Toggle(isOn: $state.isShowingInspector) {
                Label(state.isShowingInspector ? "Hide Inspector" : "Show Inspector", systemImage: "square.trailingthird.inset.filled")
                    .symbolEffect(.bounce, value: state.isShowingInspector)
            }
        }
     }
}
