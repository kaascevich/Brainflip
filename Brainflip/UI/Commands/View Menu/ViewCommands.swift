import SwiftUI

struct ViewCommands: Commands {
    @FocusedValue(\.programState) private var state
    
    var body: some Commands {
        CommandGroup(before: .sidebar) {
            HideOutputCommand()
            HideInspectorCommand()
            Divider()
        }
    }
}
