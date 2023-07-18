import SwiftUI
import Introspect

struct ProgramCommands: Commands {
    @FocusedObject<ProgramState> var state
    
    @MainActor
    var body: some Commands {
        CommandMenu("Program") {
            RunCommand()
            StepCommand()
            StopCommand()
            Divider()
            ClearAllCommand()
            ClearInputCommand()
            ResetProgramCommand()
            Divider()
            ShowArrayCommand()
        }
    }
}

