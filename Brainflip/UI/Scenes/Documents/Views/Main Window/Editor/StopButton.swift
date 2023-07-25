import SwiftUI

<<<<<<< HEAD
struct StopButton: View {
=======
struct ResetButton: View {
>>>>>>> 563b6a557e75a6a4c1cff9e89e0e937a4dd45412
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some View {
        Button {
<<<<<<< HEAD
            state.stop()
        } label: {
            Text("Stop")
                .frame(width: 35)
        }
        .disabled(state.disableStopButton)
=======
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
>>>>>>> 563b6a557e75a6a4c1cff9e89e0e937a4dd45412
    }
}

#Preview {
<<<<<<< HEAD
    StopButton(state: previewState)
=======
    ResetButton(state: previewState)
>>>>>>> 563b6a557e75a6a4c1cff9e89e0e937a4dd45412
        .environmentObject(settings)
}
