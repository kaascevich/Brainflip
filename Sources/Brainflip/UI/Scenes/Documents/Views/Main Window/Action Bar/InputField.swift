// InputField.swift
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

struct InputField: View {
    @EnvironmentObject private var settings: AppSettings
    @Bindable var state: AppState
    
    @State private var symbolEffect = false
    
    var body: some View {
        HStack {
            TextField(
                "Type your program's input here (type ⌥⏎ or ⇧⏎ for a newline)…",
                text: $state.input,
                axis: .vertical
            )
            .fontDesign(settings.monospacedInput ? .monospaced : .default)
            .lineLimit(3, reservesSpace: true)
            .disabled(state.isRunningProgram)
            .accessibilityLabel("Input")
            .speechAlwaysIncludesPunctuation()
            .introspect(.textField, on: .macOS(.v14)) {
                $0.setAccessibilityPlaceholderValue("Use option-return or shift-return for a newline")
            }
            .onSubmit {
                state.run()
            }
            
            if settings.showCopyPasteButtons {
                VStack {
                    CopyButton {
                        state.input
                    }
                    .help("Copy")
                    .accessibilityLabel("Copy Input")
                    
                    PasteButton(payloadType: String.self) { strings in
                        symbolEffect.toggle()
                        DispatchQueue.main.async {
                            state.input = strings[0]
                        }
                    }
                    .symbolEffect(.bounce.down, value: symbolEffect)
                    .help("Paste")
                }
                .labelStyle(.iconOnly)
                .buttonStyle(.borderless)
            }
        }
    }
}

#Preview {
    InputField(state: previewState)
        .environmentObject(settings)
}
