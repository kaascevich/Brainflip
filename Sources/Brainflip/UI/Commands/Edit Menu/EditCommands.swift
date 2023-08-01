import SwiftUI

struct EditCommands: Commands {
    @FocusedValue(\.appState) private var state
    
    var body: some Commands {
        CommandGroup(after: .pasteboard) {
            Divider()
            TrimCommand()
        }
    }
}
