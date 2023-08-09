// Interpreter.swift
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
import Foundation
import Observation
import os.log

/// Provides interpretation features for a Brainflip program.
///
/// All Brainflip programs manipulate an array of at least 30,000 cells. These cells
/// store integer values, from `0` to `cellSize - 1`. A ``pointer`` is used to
/// keep track of the cell that the `+` and `-` instructions will apply to.
@Observable final class Interpreter {
    private static let logger = Logger(subsystem: bundleID, category: "Interpreter")
    
    /// The action to perform  when encountering an input instruction after end-of-input has been reached.
    let endOfInput: EndOfInput
    
    /// Actions to perform when encountering an input instruction after end-of-input has been reached.
    enum EndOfInput: Int, CaseIterable, AppEnum {
        static let typeDisplayRepresentation: TypeDisplayRepresentation = "End-of-Input Action"
        static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [
            .noChange:  "Don't change the current cell",
            .setToZero: "Set the current cell to zero",
            .setToMax:  "Set the current cell to its maximum"
        ]
        
        /// Leaves the current cell unchanged.
        case noChange
        
        /// Sets the current cell to `0`.
        case setToZero
        
        /// Sets the current cell to `cellSize - 1`.
        case setToMax
    }
    
    /// The maximum value a cell can hold, plus 1.
    let cellSize: Int
    
    /// Whether to stop the program when a break instruction is encountered.
    let breakOnHash: Bool
    
    /// The ``Program`` that will be executed by this interpreter.
    let program: Program
    
    /// Creates a new ``Interpreter``.
    ///
    /// - Parameters:
    ///   - program: The program that will be executed by this interpreter, as a `String`.
    ///   - input: The user input to be supplied to the program.
    ///   - onEndOfInput: The action taken when encountering an input instruction after end-of-input has been reached.
    ///   - arraySize: The maximum capacity of the array.
    ///   - pointerLocation: The initial location for the ``pointer``.
    ///   - cellSize: The maximum value a cell can hold, plus 1.
    ///   - breakOnHash: Whether to stop the program when a break instruction is encountered.
    init(
        program: String,
        input:                   String     = "",
        onEndOfInput:            EndOfInput = .noChange,
        arraySize:               Int        = 30_000,
        pointerLocation:         Int        = 0,
        cellSize:                Int        = 256,
        breakOnHash:             Bool       = false
    ) {
        self.cellSize        = cellSize
        self.arraySize       = arraySize
        self.array           = Array(repeating: 0, count: pointerLocation + 1) + Array(repeating: nil, count: arraySize - 1)
        self.pointerLocation = pointerLocation
        self.pointer         = pointerLocation
        self.endOfInput      = onEndOfInput
        self.programString   = program
        self.program         = Program(string: program)
        self.input           = input
        self.breakOnHash     = breakOnHash
        
        self.loops = {
            var array: [Int] = []
            var stack = [0]
            var numLoops = 0
            var current = 0
            for instruction in Program(string: program) {
                switch instruction {
                case .conditional:
                    stack.append(current)
                    numLoops += 1
                    current = numLoops
                    array.append(current)
                case .loop:
                    array.append(current)
                    current = stack.popLast() ?? 0
                default:
                    array.append(current)
                }
            }
            return array
        }()
    }
    
    /// The `String` representation of the program, including comments.
    let programString: String
    
    /// The current location of the instruction ``pointer``.
    private(set) var currentInstructionIndex = 0
    
    /// The next ``Instruction`` to be executed.
    var currentInstruction: Instruction {
        guard program.indices.contains(currentInstructionIndex) else {
            return .blank
        }
        return program[currentInstructionIndex]
    }
    
    /// The previous location of the instruction ``pointer``.
    var previousInstructionIndex = 0
    
    /// The ``Instruction`` that was previously executed.
    var previousInstruction: Instruction {
        guard !program.isEmpty, previousInstructionIndex > 0 else {
            return .blank
        }
        return program[previousInstructionIndex]
    }
    
    private(set) var loops: [Int]
    
    /// The maximum size of the array.
    let arraySize: Int
    
    private var array: [Int?]
    
    /// The array used by the program.
    ///
    /// When the interpreter is initialized, the array is completely filled with `nil`s, save for
    /// a single `0` at index `0`. When the pointer moves to a cell that is `nil`, the cell
    /// is automatically set to `0`. This enables a more concise inspector implementation.
    var cellArray: [Int] { array.compactMap { $0 } }
    
    /// The amount of non-`nil` cells that are currently in the array.
    private(set) var currentArraySize = 1
    
    /// The pointer used to mark the current cell's location.
    private(set) var pointer = 0
    
    /// The initial location of the pointer.
    private(set) var pointerLocation: Int
    
    /// The contents of the cell the pointer is pointing to.
    var currentCell: Int {
        get {
            if array.indices.contains(pointer) {
                array[pointer] ?? 0
            } else { 0 }
        }
        set {
            if array.indices.contains(pointer) {
                array[pointer] = newValue
            }
        }
    }
    
    /// The current cell's value, represeted as an ASCII character.
    var currentCellAsASCII: String {
        guard asciiValues.indices.contains(currentCell) else {
            return "N/A"
        }
        return asciiValues[currentCell]
    }
    
    /// The output produced by the program.
    private(set) var output = ""
    
    /// The input passed to the program.
    let input: String
    
    /// The amount of times the program has executed the `,` instruction.
    ///
    /// This is used to keep track of the next character that will be passed to the program.
    private(set) var currentInputIndex = 0
    
    /// The character that will be passed to the program upon encountering a `,` instruction.
    ///
    /// This returns `"\0"` if end-of-input has been reached.
    var currentInputCharacter: Character {
        guard currentInputIndex <= input.count - 1 else {
            return Character("\0")
        }
        return input[input.index(input.startIndex, offsetBy: currentInputIndex)]
    }
    
    /// The current input character, represented as an ASCII character.
    var currentInputCharacterAsASCII: String {
        guard currentInputIndex <= input.count - 1 else {
            return "Null"
        }
        return asciiValues[Int(currentInputCharacter.asciiValue ?? 0)]
    }
    
    /// The total number of instructions that have been executed.
    private(set) var totalInstructionsExecuted = 0
    
    /// The total number of pointer movement instructions (<>) that have been executed.
    private(set) var totalPointerMovementInstructionsExecuted = 0

    /// The total number of cell manipulation instructions (+-) that have been executed.
    private(set) var totalCellManipulationInstructionsExecuted = 0

    /// The total number of control flow instructions ([]) that have been executed.
    private(set) var totalControlFlowInstructionsExecuted = 0

    /// The total number of I/O instructions (.,) that have been executed.
    private(set) var totalIOInstructionsExecuted = 0
}

// MARK: - Running

@Observable extension Interpreter {
    /// Runs the program.
    ///
    /// - Throws: `InterpreterError`.
    func run() async throws {
        Interpreter.logger.info("Running full program")
        
        totalInstructionsExecuted = 0
        currentInstructionIndex = 0
        output = ""
        try checkForMismatchedBrackets()
        
        while currentInstructionIndex < program.count {
            try processInstruction(currentInstruction)
            currentInstructionIndex += 1
            guard !Task.isCancelled else {
                Interpreter.logger.error("Run cancelled!"); return
            }
        }
        
        currentInstructionIndex -= 1
        totalInstructionsExecuted -= 1
        
        Interpreter.logger.info("Done running program")
    }
    
    /// Steps through the program, one instruction at a time.
    ///
    /// - Throws: `InterpreterError`.
    func step() throws {
        guard currentInstructionIndex < program.count - 1 else {
            return
        }
        Interpreter.logger.info("Stepping through program")
        try checkForMismatchedBrackets()
        try processInstruction(currentInstruction)
        currentInstructionIndex += 1
    }
    
    func checkForMismatchedBrackets() throws {
        let leftBracketCount  = program.count(of: .conditional)
        let rightBracketCount = program.count(of: .loop)
        
        guard leftBracketCount == rightBracketCount, loops.last == 0
        else { throw InterpreterError.mismatchedBrackets }
    }
}

// MARK: - Convenience Initializers

@Observable extension Interpreter {
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

// MARK: - Instruction Processing

@Observable extension Interpreter {
    /// Executes an `Instruction`.
    ///
    /// - Parameters:
    ///   - instruction: The `Instruction` to be executed.
    ///
    /// - Throws: `InterpreterError`.
    private func processInstruction(_ instruction: Instruction) throws {
        // logger.log("Processing instruction \"\(instruction.rawValue)\"")
        previousInstructionIndex = currentInstructionIndex
        switch instruction {
        case .moveRight: try processMoveRightInstruction()
        case .moveLeft:  try processMoveLeftInstruction()
        
        case .increment: try processIncrementInstruction()
        case .decrement: try processDecrementInstruction()
        
        case .conditional where currentCell == 0: try processBracket(type: .loop)        // skip the loop
        case .loop        where currentCell != 0: try processBracket(type: .conditional) // restart the loop
        
        case .output where currentCell < 256: output += String(Unicode.Scalar(currentCell)!)
        case .input: try processInputInstruction()
        
        case .break where breakOnHash: throw InterpreterError.break
        
        default: break
        }
        
        incrementTotalInstructionsExecuted(forType: instruction)
    }
    
    private func processMoveRightInstruction() throws {
        pointer += 1
        guard pointer < array.count else {
            throw InterpreterError.overflow
        }
        
        if array[pointer] == nil {
            array[pointer] = 0
            currentArraySize += 1
        }
    }
    
    private func processMoveLeftInstruction() throws {
        pointer -= 1
        guard pointer >= 0 else {
            throw InterpreterError.underflow
        }
    }
    
    private func processIncrementInstruction() throws {
        if currentCell < cellSize {
            currentCell += 1
        } else {
            currentCell = 0
        }
    }
    
    private func processDecrementInstruction() throws {
        if currentCell > 0 {
            currentCell -= 1
        } else {
            currentCell = cellSize - 1
        }
    }
    
    private func processBracket(type: Instruction) throws {
        guard type == .conditional || type == .loop else {
            return
        }
        
        let newInstructionIndex = program.indices.first { index in
            program[index] == type && loops[index] == loops[currentInstructionIndex]
        }
        guard let newInstructionIndex else {
            throw InterpreterError.mismatchedBrackets
        }
        
        currentInstructionIndex = newInstructionIndex
    }
    
    private func processInputInstruction() throws {
        if currentInputIndex == input.count {
            currentCell = switch endOfInput {
            case .noChange:  currentCell
            case .setToZero: 0
            case .setToMax:  cellSize - 1
            }
        } else {
            currentCell = min(
                cellSize - 1,
                Int(currentInputCharacter.unicodeScalars.first?.value ?? 0)
            )
            currentInputIndex += 1
        }
    }
    
    private func incrementTotalInstructionsExecuted(forType instruction: Instruction) {
        totalInstructionsExecuted += 1
        switch instruction {
        case .moveLeft,    .moveRight: totalPointerMovementInstructionsExecuted  += 1
        case .increment,   .decrement: totalCellManipulationInstructionsExecuted += 1
        case .conditional, .loop:      totalControlFlowInstructionsExecuted      += 1
        case .output,      .input:     totalIOInstructionsExecuted               += 1
        default: break
        }
    }
}
