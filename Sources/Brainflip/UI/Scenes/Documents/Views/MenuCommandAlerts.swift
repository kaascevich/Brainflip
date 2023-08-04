import SwiftUI

struct MenuCommandAlerts: View {
    @EnvironmentObject private var settings: AppSettings
    @Bindable var state: AppState
    
    var body: some View {
        Rectangle()
            .frame(width: 0, height: 0)
            .fileExporter(
                isPresented: $state.isAskingForOutputFile,
                document: state.convertedDocument,
                contentType: .cSource,
                defaultFilename: state.document.filename
            ) { _ in }
            .confirmationDialog("Trimming will remove all characters that are not valid Brainflip instructions, such as comments and newlines. Are you sure you want to do this?", isPresented: $state.isWarningAboutTrim) {
                Button("Trim") {
                    state.document.contents.removeAll { !Instruction.validInstructions.contains($0) }
                }
            } message: {
                Text("You cannot undo this action.")
            }
            .sheet(isPresented: $state.isConversionProgressShowing) {
                HStack {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .controlSize(.small)
                        .padding(0.00000000001)
                    Text("Converting")
                }
                .padding()
            }
        Rectangle()
            .frame(width: 0, height: 0)
            .alert("About Exporting to C Source", isPresented: $state.isInformingAboutCExport) {
                Button("OK") {
                    state.exportToC()
                }
            } message: {
                Text("""
                When you export your Brainflip program as a C source file, Brainflip will translate your program into C source code, ignoring comments. When compiled with an external tool, this code will behave just as your Brainflip program did, with the following exceptions:
                
                • Input will only be requested upon reaching an input instruction. If the program appears to be stuck, it might be waiting for user input; type one character and press return. (To signal end-of-input, press return without typing anything else.)
                • Unless otherwise stated below, your current settings will be applied to the generated C code. Different C code will be created for different settings.
                • If the end-of-input setting is set to "Set the current cell to <maximum value>", the generated program will behave as if it is set to "Set the current cell to zero"; be aware that this might cause incompatibility with some programs.
                • If the cell size is set to 1-bit, 2-bit, or 4-bit, the generated program will behave as if it is set to 8-bit. This might also cause incompatibility.
                """
                )
            }
            .dialogSuppressionToggle(isSuppressed: $settings.exportToCAlertHidden)
    }
}
