// PointerNameField.swift
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

struct PointerNameField: View {
    @EnvironmentObject private var settings: AppSettings
    
    // We can't use our own settings object because of the whole
    // "property initalizers run before `self` is available" thing. So
    // we're using the global object instead.
    @State private var pointerName = Brainflip.settings.pointerName
    
    private var isPointerNameValid: Bool {
        !pointerName.wholeMatch(of: BrainflipToC.identifierRegex).isNil
    }
        
    var body: some View {
        TextField(text: $pointerName) {
            HStack {
                Text("Pointer name")
                IdentifierNameHelpView(isWarningShown: isPointerNameValid)
            }
        }
        // Update it live...
        .onChange(of: pointerName) {
            if isPointerNameValid {
                settings.pointerName = pointerName // apply the new value
            }
        }
        // ...but reset it if needed
        .onSubmit {
            if !isPointerNameValid {
                pointerName = settings.pointerName // restore the old value
            }
        }
    }
}

#Preview {
    PointerNameField()
        .environmentObject(settings)
}
