import Foundation
import os.log
import AppIntents
import Observation

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
        static let caseDisplayRepresentations: [EndOfInput: DisplayRepresentation] = [
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
            var array:   [Int] = [ ]
            var stack:   [Int] = [0]
            var numLoops: Int  =  0
            var current:  Int  =  0
            for instruction in Program(string: program) {
                switch instruction {
                    case .conditional:
                        stack.append(current)
                        numLoops += 1
                        current   = numLoops
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
        guard  program.indices.contains(currentInstructionIndex) else { return .blank }
        return program[currentInstructionIndex]
    }
    
    /// The previous location of the instruction ``pointer``.
    var previousInstructionIndex = 0
    
    /// The ``Instruction`` that was previously executed.
    var previousInstruction: Instruction {
        guard  program.count > 0, previousInstructionIndex > 0 else { return .blank }
        return program[previousInstructionIndex]
    }
    
    /// An array of `Int`s that stores the total number of comment characters encountered so far.
    ///
    /// One can think of this as the difference between `string.count` and
    /// `Program(from: string).count`, where
    /// `string == programString[0..<index]`.
    var commentCharacters: [Int] {
        var array: [Int] = []
        var numCommentCharacters = 0
        for character in programString {
            array.append(numCommentCharacters)
            if !Instruction.validInstructions.contains(character) {
                numCommentCharacters += 1
                array.removeLast()
            }
        }
        return array
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
        guard  asciiValues.indices.contains(currentCell) else { return "N/A" }
        return asciiValues[currentCell]
    }
    
    /// The output produced by the program.
    private(set) var output: String = ""
    
    /// The input passed to the program.
    let input: String
    
    /// Whether the program has run out of input characters.
    private(set) var hasReachedEndOfInput = false
    
    /// The amount of times the program has executed the `,` instruction.
    ///
    /// This is used to keep track of the next character that will be passed to the program.
    private(set) var currentInputIndex = 0
    
    /// The character that will be passed to the program upon encountering a `,` instruction.
    ///
    /// This returns `"\0"` if end-of-input has been reached.
    var currentInputCharacter: Character {
        guard  currentInputIndex <= input.count - 1 else { return Character("\0") }
        return input[input.index(input.startIndex, offsetBy: currentInputIndex)]
    }
    
    /// The current input character, represented as an ASCII character.
    var currentInputCharacterAsASCII: String {
        guard  currentInputIndex <= input.count - 1 else { return "Null" }
        return asciiValues[Int(currentInputCharacter.asciiValue!)]
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
    /// Executes an `Instruction`.
    ///
    /// - Parameters:
    ///   - instruction: The `Instruction` to be executed.
    ///
    /// - Throws: `InterpreterError`.
    private func processInstruction(_ instruction: Instruction) throws {
        //logger.log("Processing instruction \"\(instruction.rawValue)\"")
        previousInstructionIndex = currentInstructionIndex
        switch instruction {
            case .moveRight:
                pointer += 1
                if pointer >= array.count {
                    throw InterpreterError.overflow(location: previousInstructionIndex)
                }
                else if array[pointer] == nil {
                    array[pointer] = 0
                    currentArraySize += 1
                }
                
            case .moveLeft:
                pointer -= 1
                guard pointer >= 0 else {
                    throw InterpreterError.underflow(location: previousInstructionIndex)
                }
                
            case .increment:
                if currentCell < cellSize {
                    currentCell += 1
                } else {
                    currentCell = 0
                }
                
            case .decrement:
                if currentCell > 0 {
                    currentCell -= 1
                } else {
                    currentCell = cellSize - 1
                }
                
            case .conditional where currentCell == 0:
                currentInstructionIndex = try searchForClosingBracket() // skip the loop
                
            case .loop where currentCell != 0:
                currentInstructionIndex = try searchForOpeningBracket() // restart the loop
                
            case .output:
                if currentCell < 256 {
                    output += String(Unicode.Scalar(currentCell)!)
                }
                
            case .input where !hasReachedEndOfInput:
                if currentInputIndex == input.count {
                    switch endOfInput {
                        case .noChange:  currentCell = currentCell
                        case .setToZero: currentCell = 0
                        case .setToMax:  currentCell = cellSize - 1
                    }
                    hasReachedEndOfInput = true
                } else {
                    currentCell = min(
                        cellSize - 1,
                        Int(currentInputCharacter.unicodeScalars.first?.value ?? 0)
                    )
                }
                
                currentInputIndex += 1
                
            case .break where breakOnHash:
                throw InterpreterError.break
                
            default: break
        }
        
        totalInstructionsExecuted += 1
        switch instruction {
            case .moveLeft,    .moveRight: totalPointerMovementInstructionsExecuted  += 1
            case .increment,   .decrement: totalCellManipulationInstructionsExecuted += 1
            case .conditional, .loop:      totalControlFlowInstructionsExecuted      += 1
            case .output,      .input:     totalIOInstructionsExecuted               += 1
            default: break
        }
    }
    
    /// Runs the program.
    ///
    /// - Throws: `InterpreterError`.
    func run() async throws {
        Interpreter.logger.info("Running full program")
        
        totalInstructionsExecuted = 0
        currentInstructionIndex   = 0
        hasReachedEndOfInput      = false
        output                    = ""
        try checkForMismatchedBrackets()
        
        while currentInstructionIndex < program.count {
            try processInstruction(currentInstruction)
            currentInstructionIndex += 1
            guard !Task.isCancelled else {
                Interpreter.logger.error("Run cancelled!")
                return
            }
        }
        
        currentInstructionIndex   -= 1
        totalInstructionsExecuted -= 1
        
        Interpreter.logger.info("Done running program")
    }
    
    /// Steps through the program, one instruction at a time.
    ///
    /// - Throws: `InterpreterError`.
    func step() throws {
        guard currentInstructionIndex < program.count - 1 else { return }
        Interpreter.logger.info("Stepping through program")
        try checkForMismatchedBrackets()
        try processInstruction(currentInstruction)
        currentInstructionIndex += 1
    }
    
    func checkForMismatchedBrackets() throws {
        let leftBracketCount  = program.count(of: .conditional)
        let rightBracketCount = program.count(of: .loop)
        
        guard leftBracketCount == rightBracketCount, loops.last == 0
        else { throw InterpreterError.mismatchedBrackets(leftBracketCount: leftBracketCount, rightBracketCount: rightBracketCount) }
    }
    
    private func searchForClosingBracket() throws -> Int {
        for (index, instruction) in program.enumerated() {
            if instruction  == .loop,
               loops[index] ==  loops[currentInstructionIndex]
            { return index }
        }
        throw InterpreterError.mismatchedBrackets(
            leftBracketCount:  program.count(of: .conditional),
            rightBracketCount: program.count(of: .loop)
        )
    }
    
    private func searchForOpeningBracket() throws -> Int {
        for (index, instruction) in program.enumerated() {
            if instruction  == .conditional,
               loops[index] ==  loops[currentInstructionIndex]
            { return index }
        }
        throw InterpreterError.mismatchedBrackets(
            leftBracketCount:  program.count(of: .conditional),
            rightBracketCount: program.count(of: .loop)
        )
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
            breakOnHash:     breakOnHash)
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
        cellSize:        CellSize,
        breakOnHash:     Bool       = false
    ) {
        self.init(
            program:         program,
            input:           input,
            onEndOfInput:    onEndOfInput,
            arraySize:       arraySize,
            pointerLocation: pointerLocation,
            cellSize:        cellSize.rawValue + 1,
            breakOnHash:     breakOnHash)
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
        cellSize:        CellSize,
        breakOnHash:     Bool       = false
    ) {
        self.init(
            program:         String(program.map(\.rawValue)),
            input:           input,
            onEndOfInput:    onEndOfInput,
            arraySize:       arraySize,
            pointerLocation: pointerLocation,
            cellSize:        cellSize.rawValue + 1,
            breakOnHash:     breakOnHash)
    }
}
