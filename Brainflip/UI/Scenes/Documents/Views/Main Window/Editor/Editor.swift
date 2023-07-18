import SwiftUI
import HighlightedTextEditor
import SwiftUIIntrospect

struct Editor: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    private var highlightRules: [HighlightRule] {
        SyntaxHighlighting.highlightRules + [
            HighlightRule(
                pattern: try! NSRegularExpression(pattern: "#"),
                formattingRule: TextFormattingRule(
                    key: .foregroundColor,
                    value: NSColor(settings.breakOnHash ? Color.green : Color.gray)
                )
            )
        ]
    }
    
    func applyTextViewSettings(_ textView: NSTextView) {
        textView.font = settings.monospaced ? .monospacedSystemFont(ofSize: settings.textSize, weight: .regular) : .systemFont(ofSize: settings.textSize)
        textView.allowsCharacterPickerTouchBarItem = false
        textView.allowsUndo = true
        textView.isRichText = false
        textView.isEditable = !state.isRunningProgram
        textView.isSelectable = !state.isRunningProgram
        if settings.showCurrentInstruction {
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
                    highlightRules: highlightRules
                )
                .introspect { applyTextViewSettings($0.textView) }
            } else {
                TextEditor(text: $state.document.contents)
                    .introspect(.textEditor, on: .macOS(.v14)) { applyTextViewSettings($0) }
            }
        }
        .onChange(of: state.document.program) {
            if state.interpreter.currentInstructionIndex != 0 {
                state.reset()
            }
        }
    }
}

private struct Editor_Previews: PreviewProvider {
    @State private static var document = ProgramDocument(",[>+<-.]")
    
    static var previews: some View {
        Editor(state: ProgramState(document: document, filename: "File.bf"))
            .environmentObject(settings)
    }
}

