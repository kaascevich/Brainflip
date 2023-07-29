import SwiftUI

struct EditCommands: Commands {
    @FocusedValue(\.programState) private var state
    
    var body: some Commands {
        CommandGroup(after: .pasteboard) {
            Divider()
            TrimCommand()
        }
    }
}
