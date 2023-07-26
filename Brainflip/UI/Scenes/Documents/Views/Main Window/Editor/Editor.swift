import SwiftUI
import HighlightedTextEditor
import SwiftUIIntrospect

struct Editor: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    private static let wrappingParagraphStyle: NSParagraphStyle = {
        let paragraphStyle: NSMutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = NSLineBreakMode.byCharWrapping
        return paragraphStyle
    }()
    
    var body: some View {
        HighlightedTextEditor(
            text: $state.document.contents,
            highlightRules: settings.highlighting ? SyntaxHighlighting.highlightRules : []
        )
        .introspect {
            $0.textView.font = settings.monospaced ? .monospacedSystemFont(ofSize: settings.textSize, weight: .regular) : .systemFont(ofSize: settings.textSize)
            $0.textView.defaultParagraphStyle = Editor.wrappingParagraphStyle
            
            $0.textView.allowsUndo = true
            $0.textView.isEditable = !state.isRunningProgram
            
            if settings.showCurrentInstruction {
                $0.textView.textStorage?.addAttributes(
                    [
                        .backgroundColor: NSColor.findHighlightColor,
                        .foregroundColor: NSColor.black
                    ],
                    range: NSRange(state.selection)
                )
            }
            
            $0.textView.setAccessibilityLabel("Editor")
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
