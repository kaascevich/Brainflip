import SwiftUI

struct ResetButton: View {
    @EnvironmentObject private var settings: AppSettings
    @Environment(AppState.self) private var state: AppState
    
    var body: some View {
        Button {
            state.reset()
        } label: {
            Text("Reset")
                .frame(width: 35)
        }
        .disabled(state.disableResetButton)
    }
}

#Preview {
    ResetButton()
        .environmentObject(settings)
        .environment(previewState)
}
