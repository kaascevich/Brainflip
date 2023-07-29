import SwiftUI

struct ToolbarClearMenu: ToolbarContent {
    @EnvironmentObject private var settings: AppSettings
    @Environment(ProgramState.self) var state: ProgramState
    
    var body: some ToolbarContent {
        ToolbarItem {
            Menu {
                ClearInputButton(state: state)
                ClearAllButton(state: state)
            } label: {
                Label("Clear", systemImage: "xmark")
                    .symbolVariant(.circle)
                    .symbolVariant(.fill)
            }
        }
    }
}
