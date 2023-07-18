import SwiftUI

struct ActionButtons: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some View {
        Group {
            RunButton(state: state)
                .buttonStyle(.borderedProminent)
                .keyboardShortcut(.defaultAction)
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

private struct ActionButtons_Previews: PreviewProvider {
    @State private static var document = ProgramDocument(",[>+<-.]")
    
    static var previews: some View {
        ActionButtons(state: ProgramState(document: document))
            .environmentObject(settings)
    }
}

