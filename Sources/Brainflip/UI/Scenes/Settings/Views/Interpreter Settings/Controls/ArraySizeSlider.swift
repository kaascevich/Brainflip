// ArraySizeSlider.swift
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

struct ArraySizeSlider: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Slider(value: settings.$arraySize, in: 30_000...60_000, step: 1000) {
            StepperField(value: settings.$arraySize, in: 30_000...60_000, label: "Array size")
        }
        .accessibilityValue(String(settings.arraySize))
        .help("Controls the size of the array.")
    }
}

#Preview {
    ArraySizeSlider()
        .environmentObject(settings)
}
