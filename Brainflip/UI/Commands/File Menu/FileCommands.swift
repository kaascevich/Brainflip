import SwiftUI

struct FileCommands: Commands {
    @FocusedValue(\.appState) private var state
    
    var body: some Commands {
        SampleProgramCommands()
        ExportCommands()
    }
}
