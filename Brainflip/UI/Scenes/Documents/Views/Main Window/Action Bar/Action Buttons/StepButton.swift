import SwiftUI

struct StepButton: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some View {
        Button {
            state.step()
        } label: {
            Label("Step Through", systemImage: "arrowshape.bounce.forward.fill")
        }
        .buttonStyle(.bordered)
        .disabled(state.disableStepButton)
    }
}

private struct StepButton_Previews: PreviewProvider {
    @State private static var document = ProgramDocument(",[>+<-.]")
    
    static var previews: some View {
        StepButton(state: ProgramState(document: document))
            .environmentObject(settings)
    }
}
