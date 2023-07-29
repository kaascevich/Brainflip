import SwiftUI

struct ExportCommands: Commands {
    @FocusedObject<ProgramState> var state
    
    var body: some Commands {
        CommandGroup(replacing: .importExport) {
            Menu("Export") {
                ExportToCCommand()
            }
            .disabled(
                state == nil
                || state!.isAskingForOutputFile
                || state!.isInformingAboutCExport
                || state!.isConversionProgressShowing
                || (try? Interpreter(program: state!.document.program).checkForMismatchedBrackets()) == nil
                || state!.isRunningProgram
            )
            .accessibilityIdentifier("exportDocument:")
        }
    }
}
