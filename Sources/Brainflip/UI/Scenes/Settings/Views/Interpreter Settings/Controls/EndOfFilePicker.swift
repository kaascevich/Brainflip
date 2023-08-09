// EndOfFilePicker.swift
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

struct EndOfFilePicker: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Picker("When there’s no input left:", selection: settings.$endOfInput) {
            ForEach(Interpreter.EndOfInput.allCases, id: \.self) { setting in
                Text(endOfInputSettingName(setting))
            }
        }
        .help("Controls the action the interpreter takes when it encounters an input command, but there are no input characters remaining.")
    }
    
    func endOfInputSettingName(_ endOfInput: Interpreter.EndOfInput) -> String {
        switch endOfInput {
        case .noChange:
            return "Leave the current cell unchanged"
        case .setToZero:
            return "Set the current cell to zero"
        case .setToMax:
            return "Set the current cell to \(settings.cellSize.rawValue.formatted())"
        }
    }
}

#Preview {
    EndOfFilePicker()
        .environmentObject(settings)
}
