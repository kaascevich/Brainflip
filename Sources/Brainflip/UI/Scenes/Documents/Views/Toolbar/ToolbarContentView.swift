import SwiftUI

struct ToolbarContentView: ToolbarContent {
    @EnvironmentObject private var settings: AppSettings
    @Environment(AppState.self) private var state: AppState
    
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
