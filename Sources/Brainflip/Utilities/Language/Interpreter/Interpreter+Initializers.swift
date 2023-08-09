// Interpreter+Initializers.swift
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
import Observation

extension Interpreter {
    /// Creates a new ``Interpreter``.
    ///
    /// - Parameters:
    ///   - program: The program that will be executed by this interpreter.
    ///   - input: The user input to be supplied to the program.
    ///   - onEndOfInput: The action taken when encountering an input instruction after end-of-input has been reached.
    ///   - arraySize: The maximum capacity of the array.
    ///   - pointerLocation: The initial location for the ``pointer``.
    ///   - cellSize: The maximum value a cell can hold, plus 1.
    ///   - breakOnHash: Whether to stop the program when a break instruction is encountered.
    convenience init(
        program:         Program,
        input:           String     = "",
        onEndOfInput:    EndOfInput = .noChange,
        arraySize:       Int        = 30_000,
        pointerLocation: Int        = 0,
        cellSize:        Int        = 256,
        breakOnHash:     Bool       = false
    ) {
        self.init(
            program:         String(program.map(\.rawValue)),
            input:           input,
            onEndOfInput:    onEndOfInput,
            arraySize:       arraySize,
            pointerLocation: pointerLocation,
            cellSize:        cellSize,
            breakOnHash:     breakOnHash
        )
    }
    
    /// Creates a new ``Interpreter``.
    ///
    /// - Parameters:
    ///   - program: The program that will be executed by this interpreter, as a `String`.
    ///   - input: The user input to be supplied to the program.
    ///   - onEndOfInput: The action taken when encountering an input instruction after end-of-input has been reached.
    ///   - arraySize: The maximum capacity of the array.
    ///   - pointerLocation: The initial location for the ``pointer``.
    ///   - cellSize: A `cellSize` instance representing the maximum value a cell can hold.
    ///   - breakOnHash: Whether to stop the program when a break instruction is encountered.
    convenience init(
        program:         String,
        input:           String     = "",
        onEndOfInput:    EndOfInput = .noChange,
        arraySize:       Int        = 30_000,
        pointerLocation: Int        = 0,
        cellSize:        CellSize, // no default argument because that would cause ambiguity
        breakOnHash:     Bool       = false
    ) {
        self.init(
            program:         program,
            input:           input,
            onEndOfInput:    onEndOfInput,
            arraySize:       arraySize,
            pointerLocation: pointerLocation,
            cellSize:        cellSize.rawValue + 1,
            breakOnHash:     breakOnHash
        )
    }
    
    /// Creates a new ``Interpreter``.
    ///
    /// - Parameters:
    ///   - program: The program that will be executed by this interpreter.
    ///   - input: The user input to be supplied to the program.
    ///   - onEndOfInput: The action taken when encountering an input instruction after end-of-input has been reached.
    ///   - arraySize: The maximum capacity of the array.
    ///   - pointerLocation: The initial location for the ``pointer``.
    ///   - cellSize: A `cellSize` instance representing the maximum value a cell can hold.
    ///   - breakOnHash: Whether to stop the program when a break instruction is encountered.
    convenience init(
        program:         Program,
        input:           String     = "",
        onEndOfInput:    EndOfInput = .noChange,
        arraySize:       Int        = 30_000,
        pointerLocation: Int        = 0,
        cellSize:        CellSize, // no default argument because that would cause ambiguity
        breakOnHash:     Bool       = false
    ) {
        self.init(
            program:         String(program.map(\.rawValue)),
            input:           input,
            onEndOfInput:    onEndOfInput,
            arraySize:       arraySize,
            pointerLocation: pointerLocation,
            cellSize:        cellSize.rawValue + 1,
            breakOnHash:     breakOnHash
        )
    }
}
