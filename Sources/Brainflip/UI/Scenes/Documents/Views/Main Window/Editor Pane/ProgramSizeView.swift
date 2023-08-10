// ProgramSizeView.swift
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

struct ProgramSizeView: View {
    @Environment(AppState.self) private var state: AppState
    
    private var programSize: String {
        let byteCountFormatStyle = ByteCountFormatStyle(
            style: .file,
            allowedUnits: .bytes,
            spellsOutZero: false
        )
        
        let fullByteCount = (state.document.contents.utf8.count).formatted(byteCountFormatStyle)
        let executableByteCount = (state.document.program.count - 1).formatted(byteCountFormatStyle)
        
        return "\(fullByteCount), \(executableByteCount) executable"
    }
    
    var body: some View {
        Text("Program size: \(programSize)")
            .accessibilityRespondsToUserInteraction()
            .accessibilityLabel("Program Size")
            .accessibilityValue(programSize)
    }
}

#Preview {
    ProgramSizeView()
        .environment(previewState)
}
