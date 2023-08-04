import SwiftUI
import HighlightedTextEditor
import SwiftUIIntrospect

struct EditorView: View {
    @EnvironmentObject private var settings: AppSettings
    @Bindable var state: AppState
    
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

extension EditorView {
    // This gets called every time document.contents changes, so let's try
    // to keep it as simple as possible.
    func applyTextViewAttributes(to textView: NSTextView) {
        textView.font = if settings.monospaced {
            .monospacedSystemFont(ofSize: settings.textSize, weight: .regular)
        } else {
            .systemFont(ofSize: settings.textSize)
        }
        
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
    EditorView(state: previewState)
        .environmentObject(settings)
}
