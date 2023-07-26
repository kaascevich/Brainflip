import SwiftUI

struct RunButton: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some View {
        Button {
            state.run()
        } label: {
            HStack {
                if state.isRunningProgram {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .controlSize(.small)
                        .padding(.leastNonzeroMagnitude)
                } else {
                    Image(systemName: "play")
                        .symbolVariant(.fill)
                }
                Text("Run Program")
            }
        }
        .disabled(state.disableRunButton)
        .buttonStyle(.borderedProminent)
        .keyboardShortcut(.defaultAction)
    }
}

//#Preview {
//    RunButton(state: previewState)
//        .environmentObject(settings)
//}
