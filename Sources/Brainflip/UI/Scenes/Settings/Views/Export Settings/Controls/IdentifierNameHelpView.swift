// IdentifierNameHelpView.swift
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

struct IdentifierNameHelpView: View {
    @State private var isShowingHelp = false
    var isWarningShown: Bool
    
    var body: some View {
        #symbolImage("exclamationmark.triangle")
            .symbolVariant(.fill)
            .foregroundStyle(.yellow)
            .symbolEffect(.appear, isActive: isWarningShown)
        
            .onTapGesture {
                isShowingHelp.toggle()
            }
            .allowsHitTesting(!isWarningShown) // dunno why negation is necessary here, but it is
            .accessibilityAddTraits(.isButton)
        
            .popover(isPresented: $isShowingHelp) {
                Text(
                    "Identifiers in C must be 32 characters long or fewer, and must only contain underscores, uppercase and lowercase letters, and digits. (The first character must not be a digit.)"
                )
                .padding(15)
                .frame(idealWidth: 320)
                .fixedSize()
            }
    }
}

#Preview {
    IdentifierNameHelpView(isWarningShown: true)
}
