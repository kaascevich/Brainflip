import SwiftUI
import AppKit

struct ExportToCCommand: View {
    @FocusedObject<ProgramState> var state
        
    var body: some View {
        Button("Export to C Source...") {
            if !AppSettings().exportToCAlertHidden {
                let alert = NSAlert()
                alert.messageText = "About Exporting to C Source"
                alert.informativeText = """
                    When you export a Brainflip program as a C source file, Brainflip will translate your program into C source code, ignoring comments. When compiled with an external tool, this code will behave just as your Brainflip program did, with the following exceptions:
                    
                    • Input will only be requested upon reaching an input instruction. If the program appears to be stuck, it might be waiting for user input; type one character and press return. (To signal end-of-input, press return without typing anything else.)
                    • With the exception of the "Set the current cell to <maximum value>" end-of-input setting, your current settings will be applied to the generated C code. Different C code will be created for different settings.
                    • If the end-of-input setting is set to "Set the current cell to <maximum value>", the generated program will behave as if it is set to "Set the current cell to zero"; be aware that this might cause incompatibility with some programs.
                    """
                alert.showsSuppressionButton = true
                alert.runModal()
                
                if alert.suppressionButton?.state == .on {
                    AppSettings().exportToCAlertHidden = true
                }
            }
            
            state?.isAskingForOutputFile.toggle()
        }
        .disabled(state == nil || state?.isAskingForOutputFile == true)
    }
}
