import SwiftUI

struct ResetButton: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
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
    ResetButton(state: previewState)
        .environmentObject(settings)
}
