import SwiftUI
import SwiftUIIntrospect

struct OutputView: View {
    @EnvironmentObject private var settings: AppSettings
    @Environment(AppState.self) private var state: AppState
    
    var body: some View {
        TextEditor(text: .constant(state.output))
            .fontDesign(settings.monospacedOutput ? .monospaced : .default)
            .introspect(.textEditor, on: .macOS(.v14)) {
                $0.isEditable = false
                $0.usesFindPanel = true
            }
            .accessibilityTextContentType(.sourceCode)
            .accessibilityLabel("Output")
            .speechSpellsOutCharacters()
    }
}

#Preview {
    OutputPaneView()
        .environmentObject(settings)
        .environment(previewState)
}
