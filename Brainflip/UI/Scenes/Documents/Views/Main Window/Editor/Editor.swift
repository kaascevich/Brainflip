import SwiftUI
import HighlightedTextEditor

struct Editor: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    private var highlightRules: [HighlightRule] {
        var rules = SyntaxHighlighting.highlightRules
        rules.append(
            HighlightRule(
                pattern: try! NSRegularExpression(pattern: "#"),
                formattingRule: TextFormattingRule(
                    key: .foregroundColor,
                    value: NSColor(settings.breakOnHash ? Color.green : Color.gray)
                )
            )
        )
        return rules
    }
    
    var body: some View {
        Group {
            if settings.highlighting {
                HighlightedTextEditor(
                    text: $state.document.contents,
                    highlightRules: highlightRules
                )
                .introspect {
                    $0.textView.font = settings.monospaced ? .monospacedSystemFont(ofSize: 14, weight: .regular) : .systemFont(ofSize: 14)
                    $0.textView.allowsCharacterPickerTouchBarItem = false
                    $0.textView.allowsUndo = true
                    $0.textView.isRichText = false
                    $0.textView.isEditable = !state.isRunningProgram
                    if settings.showCurrentInstruction {
                        $0.textView.textStorage?.addAttributes(
                            [.backgroundColor: NSColor.findHighlightColor, .foregroundColor: NSColor.black],
                            range: NSRange(state.selection))
                    }
                }
            } else {
                TextEditor(text: $state.document.contents)
                    .font(settings.monospaced ? .system(size: 14).monospaced() : .system(size: 14))
                    .introspectTextView {
                        $0.allowsCharacterPickerTouchBarItem = false
                        $0.allowsUndo = true
                        $0.isRichText = false
                        $0.isEditable = !state.isRunningProgram
                        $0.textStorage?.addAttributes(
                            [.backgroundColor: NSColor.textBackgroundColor, .foregroundColor: NSColor.textColor],
                            range: NSRange(location: 0, length: state.document.contents.count)
                        )
                        if settings.showCurrentInstruction {
                            $0.textStorage?.addAttributes(
                                [.backgroundColor: NSColor.findHighlightColor, .foregroundColor: NSColor.black],
                                range: NSRange(state.selection))
                        }
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
            .environmentObject(AppSettings())
    }
}

