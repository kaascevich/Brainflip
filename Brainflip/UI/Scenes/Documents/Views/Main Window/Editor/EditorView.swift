import SwiftUI

struct EditorView: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    var body: some View {
        Form {
            HStack {
                Text("Type your program here...")
                Spacer()
                ResetButton(state: state)
            }
            
            Editor(state: state)
            
            HStack {
                if settings.showProgramSize {
                    Text("Program size: " + userFriendlyStringSize(state.document.contents))
                }
                Spacer()
                ClearMenu(state: state)
                    .frame(width: 65)
            }
        }
    }
}
private struct EditorView_Previews: PreviewProvider {
    @State private static var document = ProgramDocument(",[>+<-.]")
    
    static var previews: some View {
        EditorView(state: ProgramState(document: document))
            .environmentObject(AppSettings())
    }
}

