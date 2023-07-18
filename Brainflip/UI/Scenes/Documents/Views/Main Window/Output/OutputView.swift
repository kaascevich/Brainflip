import SwiftUI
import SwiftUIIntrospect

struct OutputView: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some View {
        VStack {
            HStack {
                Text("Output")
                Spacer()
                if settings.showTimer {
                    TimerView(state: state)
                }
            }
            TextEditor(text: .constant(state.output))
                .font(.monospaced(.body)())
                .introspect(.textEditor, on: .macOS(.v14)) {
                    $0.isEditable = false
                    $0.usesFindPanel = true
                }
            }
    }
}

private struct OutputView_Previews: PreviewProvider {
    @State private static var document = ProgramDocument(",[>+<-.]")
    
    static var previews: some View {
        OutputView(state: ProgramState(document: document))
            .environmentObject(settings)
    }
}

