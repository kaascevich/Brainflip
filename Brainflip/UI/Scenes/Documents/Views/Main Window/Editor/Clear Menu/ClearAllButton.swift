import SwiftUI

struct ClearAllButton: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some View {
        Button("Clear All...", role: .destructive) {
            state.isClearAlertShowing.toggle()
        }
        .disabled(state.document.contents.isEmpty || state.isRunningProgram)
    }
}

private struct ClearAllButton_Previews: PreviewProvider {
    @State private static var document = ProgramDocument(",[>+<-.]")
    
    static var previews: some View {
        ClearAllButton(state: ProgramState(document: document))
            .environmentObject(AppSettings())
    }
}
