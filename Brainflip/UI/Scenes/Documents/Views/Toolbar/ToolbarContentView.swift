import SwiftUI

struct ToolbarContentView: ToolbarContent {
    @EnvironmentObject private var settings: AppSettings
    @Environment(ProgramState.self) var state: ProgramState
    
    var body: some ToolbarContent {
        ToolbarRunButton()
        ToolbarStepButton()
        
        ToolbarDivider()
        
        ToolbarResetButton()
        ToolbarStopButton()
        ToolbarClearMenu()
        
        ToolbarDivider()
        
        ToolbarPanelToggles(state: state)
    }
}
