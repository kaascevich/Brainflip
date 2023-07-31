import SwiftUI
import SwiftUIIntrospect

struct OutputPaneView: View {
    @EnvironmentObject private var settings: AppSettings
    @Environment(AppState.self) private var state: AppState
    
    var body: some View {
        VStack {
            HStack {
                Text("Output")
                    .accessibilityHidden(true)
                Spacer()
                if settings.showTimer {
                    TimerView()
                }
                CopyButton { state.output }
            }
            TextEditor(text: .constant(state.output))
                .font(.monospaced(.body)())
                .introspect(.textEditor, on: .macOS(.v14)) {
                    $0.isEditable = false
                    $0.usesFindPanel = true
                }
                .accessibilityTextContentType(.sourceCode)
                .accessibilityLabel("Output")
                .speechSpellsOutCharacters()
        }
    }
}

#Preview {
    OutputPaneView()
        .environmentObject(settings)
        .environment(previewState)
}
