import SwiftUI

struct ToolbarClearMenu: ToolbarContent {
    @EnvironmentObject private var settings: AppSettings
    @Environment(AppState.self) private var state: AppState
    
    var body: some ToolbarContent {
        ToolbarItem {
            Menu {
                ClearInputButton()
                ClearAllButton()
            } label: {
                Label("Clear", systemImage: "xmark")
                    .symbolVariant(.circle)
                    .symbolVariant(.fill)
            }
        }
    }
}
