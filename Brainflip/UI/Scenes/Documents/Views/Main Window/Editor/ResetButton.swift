import SwiftUI

struct ResetButton: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some View {
        Button {
            if state.isRunningProgram {
                state.stop()
            } else {
                state.reset()
            }
        } label: {
            Text(state.isRunningProgram ? "Stop" : "Reset")
                .frame(width: 35)
        }
        .disabled(state.disableResetButton && state.disableStopButton)
    }
}

private struct ResetButton_Previews: PreviewProvider {
    @State private static var document = ProgramDocument(",[>+<-.]")
    
    static var previews: some View {
        ResetButton(state: ProgramState(document: document))
            .environmentObject(settings)
    }
}
