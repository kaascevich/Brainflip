import SwiftUI

struct TouchBarStopButton: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some View {
        Button {
            state.stop()
        } label: {
            Image(systemName: "octagon.fill")
                .imageScale(.large)
                .padding()
        }
        .disabled(state.disableStopButton)
    }
}

#Preview {
    TouchBarStopButton(state: previewState)
        .environmentObject(settings)
}
