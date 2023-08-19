// ExportCommands.swift
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

struct ExportCommands: Commands {
    @FocusedValue(\.appState) private var state
    
    var body: some Commands {
        CommandGroup(replacing: .importExport) {
            Menu("Export") {
                ExportToCCommand()
            }
            .disabled(
                state.isNil
                || state!.isConversionProgressShowing
                || (try? Interpreter(program: state!.document.program).checkForMismatchedBrackets()).isNil
                || state!.isRunningProgram
            )
            .accessibilityIdentifier("exportDocument:")
        }
    }
}
