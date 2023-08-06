// OutputView.swift
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
