// Instruction.swift
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

/// Instructions that can be executed by the Brainflip interpreter.
enum Instruction: Character, CaseIterable {
    /// Moves the pointer 1 cell to the right.
    ///
    /// This instruction is represented as `>`.
    case moveRight = ">"
    
    /// Moves the pointer 1 cell to the left.
    ///
    /// This instruction is represented as `<`.
    case moveLeft = "<"
    
    /// Increments the current cell's value by 1.
    ///
    /// This instruction is represented as `+`.
    case increment = "+"
    
    /// Decrements the current cell's value by 1.
    ///
    /// This instruction is represented as `-`.
    case decrement = "-"
    
    /// Checks whether the current cell's value is 0; if so, moves the instruction pointer to the matching loop command.
    ///
    /// This instruction is represented as `[`.
    case conditional = "["
    
    /// Moves the instruction pointer to the matching conditional command.
    ///
    /// This instruction is represented as `]`.
    case loop = "]"
    
    /// Outputs the ASCII equivalent of the current cell's value.
    ///
    /// This instruction is represented as `.`.
    case output = "."
    
    /// Gets the next character of user input and stores its numerical ASCII equivalent to the current cell.
    ///
    /// This instruction is represented as `,`.
    case input = ","
    
    /// If enabled, stops the program.
    ///
    /// This instruction is represented as `#`.
    case `break` = "#"
    
    /// Used to signify the start and end of the program.
    case blank = "\0"
    
    /// Returns a `String` containing all valid instructions except for the blank instruction.
    static var validInstructions: String {
        String(allCases.filter { $0 != .blank }.map(\.rawValue))
    }
}
