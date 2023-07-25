import SwiftUI
import HighlightedTextEditor
import SwiftUIIntrospect

struct Editor: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    func applyTextViewSettings(_ textView: NSTextView) {
        textView.font = settings.monospaced ? .monospacedSystemFont(ofSize: settings.textSize, weight: .regular) : .systemFont(ofSize: settings.textSize)
        textView.allowsCharacterPickerTouchBarItem = false
        textView.allowsUndo = true
        textView.isRichText = false
        textView.isEditable = !state.isRunningProgram
        textView.isSelectable = !state.isRunningProgram
        if settings.showCurrentInstruction {
            // FIXME: Current instruction highlighting
            textView.textStorage?.addAttributes(
                [.backgroundColor: NSColor.findHighlightColor, .foregroundColor: NSColor.black],
                range: NSRange(state.selection))
        }
    }
    
    var body: some View {
        Group {
            if settings.highlighting {
                HighlightedTextEditor(
                    text: $state.document.contents,
                    highlightRules: SyntaxHighlighting.highlightRules
                )
                .introspect { applyTextViewSettings($0.textView) }
            } else {
                TextEditor(text: $state.document.contents)
                    .introspect(.textEditor, on: .macOS(.v14)) {
                        applyTextViewSettings($0)
                        $0.textStorage?.addAttributes(
                            [.backgroundColor: NSColor.textBackgroundColor, .foregroundColor: NSColor.textColor],
                            range: NSRange(location: 0, length: state.document.contents.count)
                        )
                    }
            }
        }
        .onChange(of: state.document.program) {
            if state.interpreter.currentInstructionIndex != 0 {
                state.reset()
            }
        }
    }
}

#Preview {
    Editor(state: previewState)
        .environmentObject(settings)
}
