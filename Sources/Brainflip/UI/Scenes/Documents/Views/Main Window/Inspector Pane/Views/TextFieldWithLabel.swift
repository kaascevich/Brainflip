// TextFieldWithLabel.swift
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

struct TextFieldWithLabel: View {
    var text: String
    let label: String
    @Binding var isTextFieldShown: Bool
    
    init(_ text: String, label: String = "", isShown: Binding<Bool>) {
        self.text              = text
        self.label             = label
        self._isTextFieldShown = isShown
    }
    
    var body: some View {
        DisclosureGroup(label, isExpanded: $isTextFieldShown) {
            TextField("", text: .constant(text))
                .monospacedDigit()
                .introspect(.textEditor, on: .macOS(.v14)) {
                    $0.isEditable = false
                    $0.isSelectable = false
                    $0.focusRingType = .none
                }
                .accessibilityLabel(label)
        }
        .disclosureGroupStyle(AnimatedDisclosureGroupStyle())
    }
}

#Preview {
    TextFieldWithLabel(
        "Testing, content",
        label: "Testing, testing",
        isShown: .constant(true)
    )
}
