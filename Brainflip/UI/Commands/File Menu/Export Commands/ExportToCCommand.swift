import SwiftUI
import AppKit

struct ExportToCCommand: View {
    @FocusedObject<ProgramState> var state
    var convertedDocument = CSourceDocument("")
            
    var body: some View {
        Button("Export to C Source...") {
            if settings.exportToCAlertHidden {
                state?.exportToC()
            } else {
                state?.isInformingAboutCExport.toggle()
            }
        }
        .disabled(state == nil || state!.isAskingForOutputFile == true || state?.isInformingAboutCExport == true || state!.isConversionProgressShowing == true || (try? Interpreter(program: state!.document.program).checkForMismatchedBrackets()) == nil)
    }
}
