import SwiftUI

struct ToolbarContentView: ToolbarContent {
    @EnvironmentObject private var settings: AppSettings
    @StateObject var state: ProgramState
    
    var body: some ToolbarContent {
        ToolbarRunButton(state: state, placement: .primaryAction)
        ToolbarStepButton(state: state, placement: .primaryAction)
        
        ToolbarDivider(placement: .primaryAction)
        
        ToolbarResetButton(state: state, placement: .primaryAction)
        ToolbarStopButton(state: state, placement: .primaryAction)
        ToolbarClearMenu(state: state, placement: .primaryAction)
    }
}
