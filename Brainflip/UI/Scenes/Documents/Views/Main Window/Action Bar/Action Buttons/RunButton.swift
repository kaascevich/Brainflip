import SwiftUI

struct RunButton: View {
    @EnvironmentObject private var settings: AppSettings
    @Environment(AppState.self) private var state: AppState
    
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

#Preview {
    RunButton()
        .environmentObject(settings)
        .environment(previewState)
}
