import SwiftUI

struct ClearInputButton: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some View {
        Button("Clear Input") {
            state.input = ""
        }
        .disabled(state.input.isEmpty || state.isRunningProgram)
    }
}

private struct ClearInputButton_Previews: PreviewProvider {
    @State private static var document = ProgramDocument(",[>+<-.]")
    
    static var previews: some View {
        ClearInputButton(state: ProgramState(document: document))
            .environmentObject(AppSettings())
    }
}
