// Interpreter+EndOfInput.swift
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

import AppIntents

extension Interpreter {
    /// Actions to perform when encountering an input instruction after end-of-input has been reached.
    enum EndOfInput: Int, CaseIterable {
        /// Leaves the current cell unchanged.
        case noChange
        
        /// Sets the current cell to `0`.
        case setToZero
        
        /// Sets the current cell to `cellSize - 1`.
        case setToMax
    }
}

extension Interpreter.EndOfInput: AppEnum {
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "End-of-Input Action"
    static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .noChange:  "Don't change the current cell",
        .setToZero: "Set the current cell to zero",
        .setToMax:  "Set the current cell to its maximum"
    ]
    
}
