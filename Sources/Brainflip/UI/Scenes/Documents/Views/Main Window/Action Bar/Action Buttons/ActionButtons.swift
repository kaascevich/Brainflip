import SwiftUI

struct ActionButtons: View {
    @EnvironmentObject private var settings: AppSettings
    @Bindable var state: AppState
    
    var body: some View {
        Group {
            RunButton()
            StepButton()
        }
        .controlSize(.large)
        .alert("An error occured while running your program.", isPresented: $state.hasError) {
            Button("OK") { }
            if case .overflow(_)? = state.errorType, case .underflow(_)? = state.errorType {
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
