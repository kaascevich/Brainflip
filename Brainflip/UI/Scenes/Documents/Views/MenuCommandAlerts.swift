import SwiftUI

struct MenuCommandAlerts: View {
    @EnvironmentObject private var settings: AppSettings
    @StateObject var state: ProgramState
    
    var body: some View {
        Rectangle()
            .frame(width: 0, height: 0)
            .fileExporter(
                isPresented: $state.isAskingForOutputFile,
                document: CSourceDocument(BrainflipToC.convertToC(state.document.program)),
                contentType: .cSource) { _ in }
            .confirmationDialog("Trimming will remove all characters that are not valid Brainflip instructions, such as comments and newlines. Are you sure you want to do this?", isPresented: $state.isWarningAboutTrim) {
                Button("Trim") {
                    state.document.contents.removeAll { !Instruction.validInstructions.contains($0) }
                }
            } message: {
                Text("You cannot undo this action.")
            }
    }
}
