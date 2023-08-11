// CellSizePicker.swift
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

struct CellSizePicker: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Picker("Cell size", selection: settings.$cellSize) {
            ForEach(CellSize.allCases, id: \.self) { size in
                Text(size.localizedStringResource)
            }
        }
        .pickerStyle(.segmented)
        .help(
            """
            Controls the maximum value a cell can hold. Use this setting with caution.
            - 1-bit: Maximum value is 1
            - 2-bit: Maximum value is 3
            - 4-bit: Maximum value is 15
            - 8-bit: Maximum value is 255 (recommended, default)
            - 16-bit: Maximum value is 65,535
            - 32-bit: Maximum value is 4,294,967,295
            """
        )
    }
}

#Preview {
    CellSizePicker()
        .environmentObject(settings)
}
