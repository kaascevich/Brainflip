import SwiftUI

struct ExportCommands: Commands {
    @FocusedObject<ProgramState> var state
    
    var body: some Commands {
        CommandGroup(replacing: .importExport) {
            Menu("Export") {
                ExportToCCommand()
            }
        }
    }
}
