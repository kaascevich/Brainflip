import SwiftUI

struct ToolbarContentView: ToolbarContent {
    @EnvironmentObject private var settings: AppSettings
    @StateObject var state: ProgramState
    
    var body: some ToolbarContent {
        ToolbarRunButton(state: state)
        ToolbarStepButton(state: state)
        
        ToolbarDivider()
        
        ToolbarResetButton(state: state)
        ToolbarStopButton(state: state)
        ToolbarClearMenu(state: state)
        
        ToolbarDivider()
        
        ToolbarPanelToggles(state: state)
    }
}
