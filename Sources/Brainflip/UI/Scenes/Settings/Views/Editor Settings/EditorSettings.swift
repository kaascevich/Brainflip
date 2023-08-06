// EditorSettings.swift
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

struct EditorSettings: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        VStack(alignment: .trailing) {
            Form {
                Section("Font") {
                    MonospacedToggle()
                    HighlightingToggle()
                    TextSizeSlider()
                }
                Section("Progress") {
                    ShowProgressToggle()
                    ShowCurrentInstructionToggle()
                }
                Section("Other") {
                    ShowProgramSizeToggle()
                }
            }
            .formStyle(.grouped)
            
            EditorDefaultsButton()
                .padding(.horizontal)
                .padding(.bottom)
        }
    }
}

#Preview {
    EditorSettings()
        .environmentObject(settings)
}

