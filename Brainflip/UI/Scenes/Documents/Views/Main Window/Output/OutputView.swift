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

#Preview {
    OutputView(state: previewState)
        .environmentObject(settings)
}
