import SwiftUI

struct ActionButtons: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some View {
        Group {
            RunButton(state: state)
            StepButton(state: state)
        }
        .controlSize(.large)
        .alert("An error occured while running your program.", isPresented: $state.hasError) {
            Button("OK") {
                withAnimation {
                    state.isRunningProgram = false
                }
            }
            if state.errorType == .overflow || state.errorType == .underflow {
                SettingsLink()
            }
        } message: {
            Text(state.errorDescription)
        }
    }
}

//#Preview {
//    ActionButtons(state: previewState)
//        .environmentObject(settings)
//}
