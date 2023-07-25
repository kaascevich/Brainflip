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
                        .padding(0.00000000001)
                } else {
                    Image(systemName: "play")
                        .symbolVariant(.fill)
                }
                Text("Run Program")
            }
        }
        .disabled(state.disableRunButton)
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    RunButton(state: previewState)
        .environmentObject(settings)
}
