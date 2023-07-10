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
                    Image(systemName: "play.fill")
                }
                Text("Run Program")
            }
        }
        .disabled(state.disableRunButton)
        .buttonStyle(.borderedProminent)
    }
}

private struct RunButton_Previews: PreviewProvider {
    @State private static var document = ProgramDocument(",[>+<-.]")
    
    static var previews: some View {
        RunButton(state: ProgramState(document: document))
            .environmentObject(AppSettings())
    }
}
