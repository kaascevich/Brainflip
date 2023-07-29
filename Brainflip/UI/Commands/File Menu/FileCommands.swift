import SwiftUI

struct FileCommands: Commands {
    @FocusedValue(\.programState) private var state
    
    var body: some Commands {
        SampleProgramCommands()
        ExportCommands()
    }
}
