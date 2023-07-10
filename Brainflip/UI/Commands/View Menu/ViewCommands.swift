import SwiftUI

struct ViewCommands: Commands {
    @FocusedObject<ProgramState> var state
    
    var body: some Commands {
        CommandGroup(before: .sidebar) {
            HideOutputCommand()
            HideInspectorCommand()
            Divider()
        }
    }
}
