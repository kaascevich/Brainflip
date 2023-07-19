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
                    highlightRules: highlightRules
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

private struct Editor_Previews: PreviewProvider {
    @State private static var document = ProgramDocument(",[>+<-.]")
    
    static var previews: some View {
        Editor(state: ProgramState(document: document))
            .environmentObject(settings)
    }
}

