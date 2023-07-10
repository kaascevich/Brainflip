import SwiftUI

struct TouchBarStepButton: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some View {
        Button {
            state.step()
        } label: {
            Image(systemName: "arrowshape.bounce.forward.fill")
                .imageScale(.large)
                .padding(13)
        }
        .buttonStyle(.bordered)
        .disabled(state.disableStepButton)
    }
}
