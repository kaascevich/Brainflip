// InterpreterError.swift
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

import Foundation

/// Errors that can be thrown by the Brainflip interpreter.
enum InterpreterError: Error, Equatable {
    /// Thrown when the interpreter finds unmatched brackets.
    case mismatchedBrackets
    
    /// Thrown when the pointer points to a cell that is below the bounds of the array.
    case underflow
    
    /// Thrown when the pointer points to a cell that is above the bounds of the array.
    case overflow
    
    /// Thrown when encountering a break instruction (if enabled).
    case `break`
}