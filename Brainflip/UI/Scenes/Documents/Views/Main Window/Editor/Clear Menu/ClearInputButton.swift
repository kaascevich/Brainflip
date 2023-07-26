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

//#Preview {
//    ClearInputButton(state: previewState)
//        .environmentObject(settings)
//}
