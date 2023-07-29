import SwiftUI

struct ActionButtons: View {
    @EnvironmentObject private var settings: AppSettings
    @Bindable var state: ProgramState
    
    var body: some View {
        Group {
            RunButton()
            StepButton()
        }
        .controlSize(.large)
        .alert("An error occured while running your program.", isPresented: $state.hasError) {
            Button("OK") { }
            if state.errorType == .overflow || state.errorType == .underflow {
                SettingsLink()
            }
        } message: {
            Text(state.errorDescription)
        }
    }
}

#Preview {
    ActionButtons(state: previewState)
        .environmentObject(settings)
}
