import SwiftUI
import HighlightedTextEditor
import SwiftUIIntrospect

struct Editor: View {
    @EnvironmentObject private var settings: AppSettings
    @Bindable var state: ProgramState
    
    var body: some View {
        HighlightedTextEditor(
            text: $state.document.contents,
            highlightRules: settings.highlighting ? SyntaxHighlighting.highlightRules : []
        )
        .introspect { editor in
            applyTextViewAttributes(to: editor.textView)
        }
        .onChange(of: state.document.program) {
            if state.interpreter.currentInstructionIndex != 0 {
                state.reset()
            }
        }
    }
}

extension Editor {
    func applyTextViewAttributes(to textView: NSTextView) {
        textView.font = settings.monospaced ? .monospacedSystemFont(ofSize: settings.textSize, weight: .regular) : .systemFont(ofSize: settings.textSize)
        
        textView.allowsUndo = true
        textView.isEditable = !state.isRunningProgram
        textView.isSelectable = !state.isRunningProgram
        
        if settings.showCurrentInstruction && !state.isRunningProgram {
            textView.textStorage?.addAttributes(
                [
                    .backgroundColor: NSColor.findHighlightColor,
                    .foregroundColor: NSColor.black
                ],
                range: NSRange(state.selection)
            )
        }
        
        textView.setAccessibilityLabel("Editor")
        if settings.showCurrentInstruction, state.hasError || state.isSteppingThrough {
            textView.scrollRangeToVisible(NSRange(state.selection))
        }
    }
}

#Preview {
    Editor(state: previewState)
        .environmentObject(settings)
}
