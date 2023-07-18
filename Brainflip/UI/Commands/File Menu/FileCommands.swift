import SwiftUI

struct FileCommands: Commands {
    @FocusedObject<ProgramState> var state
    
    var body: some Commands {
        SampleProgramCommands()
        ExportCommands()
    }
}
