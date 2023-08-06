// PlaySoundsToggles.swift
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

struct PlaySoundsToggles: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle("Play sound effects", isOn: settings.$playSounds)
        
        Section {
            Toggle("When running program", isOn: settings.$playStartSound)
            Toggle("When program finishes running", isOn: settings.$playSuccessSound)
            Toggle("When program stops with an error", isOn: settings.$playFailSound)
            Toggle("When stepping through program", isOn: settings.$playStepSound)
        }
        .disabled(!settings.playSounds)
    }
}

#Preview {
    PlaySoundsToggles()
        .environmentObject(settings)
}
