// EditorView.swift
// Copyright © 2023 Kaleb A. Ascevich
//
// This app is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This app is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
// for more details.
//
// You should have received a copy of the GNU General Public License along
// with this app. If not, see https://www.gnu.org/licenses/.

import HighlightedTextEditor
import SwiftUI
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
        
        if settings.showCurrentInstruction,
           !state.isRunningProgram,
           !state.document.contents.isEmpty { // sanity check -- sometimes the selection doesn't update on time
            textView.textStorage?.addAttributes(
                [
                    .backgroundColor: NSColor.findHighlightColor,
                    .foregroundColor: NSColor.black
                ],
                range: NSRange(state.selection)
            )
        }
        
        textView.setAccessibilityLabel("Editor")
        if settings.showCurrentInstruction,
           state.hasError || state.isSteppingThrough,
            !state.document.contents.isEmpty { // sanity check -- sometimes the selection doesn't update on time
            textView.scrollRangeToVisible(NSRange(state.selection))
        }
    }
}

#Preview {
    EditorView(state: previewState)
        .environmentObject(settings)
}
