// ArrayNameField.swift
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

struct ArrayNameField: View {
    @EnvironmentObject private var settings: AppSettings
    
    // We can't use our own settings object because of the whole
    // "property initalizers run before `self` is available" thing. So
    // we're using the global object instead.
    @State private var arrayName = Brainflip.settings.arrayName
    
    private var isArrayNameValid: Bool {
        !arrayName.wholeMatch(of: BrainflipToC.identifierRegex).isNil
    }
    
    var body: some View {
        TextField(text: $arrayName) {
            HStack {
                Text("Array name")
                IdentifierNameHelpView(isWarningShown: isArrayNameValid)
            }
        }
        // Update it live...
        .onChange(of: arrayName) {
            if isArrayNameValid {
                settings.arrayName = arrayName // apply the new value
            }
        }
        // ...but reset it if needed
        .onSubmit {
            if !isArrayNameValid {
                arrayName = settings.arrayName // restore the old value
            }
        }
    }
}

#Preview {
    ArrayNameField()
        .environmentObject(settings)
}
