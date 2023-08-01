import SwiftUI

struct ExportCommands: Commands {
    @FocusedValue(\.appState) private var state
    
    var body: some Commands {
        CommandGroup(replacing: .importExport) {
            Menu("Export") {
                ExportToCCommand()
            }
            .disabled(
                state == nil
                || state!.isConversionProgressShowing
                || (try? Interpreter(program: state!.document.program).checkForMismatchedBrackets()) == nil
                || state!.isRunningProgram
            )
            .accessibilityIdentifier("exportDocument:")
        }
    }
}