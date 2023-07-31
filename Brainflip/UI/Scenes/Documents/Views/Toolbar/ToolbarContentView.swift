import SwiftUI

struct ToolbarContentView: ToolbarContent {
    @EnvironmentObject private var settings: AppSettings
    @Environment(\.appState) private var state: AppState
    
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
