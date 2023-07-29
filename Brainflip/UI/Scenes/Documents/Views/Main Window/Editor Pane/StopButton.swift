import SwiftUI

struct StopButton: View {
    @EnvironmentObject private var settings: AppSettings
    @Environment(ProgramState.self) private var state: ProgramState
    
    var body: some View {
        Button {
            state.stop()
        } label: {
            Text("Stop")
                .frame(width: 35)
        }
        .disabled(state.disableStopButton)
    }
}

#Preview {
    StopButton()
        .environmentObject(settings)
        .environment(previewState)
}
