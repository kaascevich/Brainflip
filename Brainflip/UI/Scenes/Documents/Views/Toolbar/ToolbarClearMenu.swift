import SwiftUI

struct ToolbarClearMenu: ToolbarContent {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    let placement: ToolbarItemPlacement
    init(state: ProgramState, placement: ToolbarItemPlacement) {
        self.state = state
        self.placement = placement
    }
    
    var body: some ToolbarContent {
        ToolbarItem(placement: placement) {
            Menu {
                ClearInputButton(state: state)
                ClearAllButton(state: state)
            } label: {
                Label("Clear", systemImage: "xmark.circle.fill")
            }
        }
    }
}
