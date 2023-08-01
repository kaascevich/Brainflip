import SwiftUI

struct ProgramCommands: Commands {
    @FocusedValue(\.appState) private var state
    
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
