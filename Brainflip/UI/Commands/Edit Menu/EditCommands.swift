import SwiftUI

struct EditCommands: Commands {
    @FocusedObject<ProgramState> var state
    
    var body: some Commands {
        CommandGroup(after: .pasteboard) {
            Divider()
            TrimCommand()
        }
    }
}
