import Foundation

/// Provides interpretation features for a Brainflip program.
///
/// All Brainflip programs manipulate an ``array`` of at least 30,000 cells. These cells
/// store integer values, from `0` to `cellSize - 1`. A ``pointer`` is used to
/// keep track of the cell that the `+` and `-` instructions will apply to.
class Interpreter {
    /// The action to perform  when encountering an input instruction after end-of-input has been reached.
    let endOfInput: EndOfInput
    
    /// Actions to perform when encountering an input instruction after end-of-input has been reached.
    enum EndOfInput: Int, CaseIterable {
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
    ///   - program: The program that will be executed by this interpreter.
    ///   - input: The user input to be supplied to the program.
    ///   - onEndOfInput: The action taken when encountering an input instruction after end-of-input has been reached.
    ///   - arraySize: The maximum capacity of the ``array``.
    ///   - pointerLocation: The initial location for the ``pointer``.
    ///   - cellSize: The maximum value a cell can hold, plus 1.
    ///   - breakOnHash: Whether to stop the program when a break instruction is encountered.
    convenience init(
        program: Program,
        input: String = "",
        onEndOfInput endOfInput: EndOfInput = .noChange,
        arraySize: Int = 30_000,
        pointerLocation: Int = 0,
        cellSize: Int = 256,
        breakOnHash: Bool = false)
    {
        self.init(
            program: String(program.map { $0.rawValue }),
            input: input,
            onEndOfInput: endOfInput,
            arraySize: arraySize,
            pointerLocation: pointerLocation,
            cellSize: cellSize,
            breakOnHash: breakOnHash)
    }
    
    /// Creates a new ``Interpreter``.
    ///
    /// - Parameters:
    ///   - program: The program that will be executed by this interpreter, as a `String`.
    ///   - input: The user input to be supplied to the program.
    ///   - onEndOfInput: The action taken when encountering an input instruction after end-of-input has been reached.
    ///   - arraySize: The maximum capacity of the ``array``.
    ///   - pointerLocation: The initial location for the ``pointer``.
    ///   - cellSize: The maximum value a cell can hold, plus 1.
    ///   - breakOnHash: Whether to stop the program when a break instruction is encountered.
    init(program: String,
         input: String = "",
         onEndOfInput endOfInput: EndOfInput = .noChange,
         arraySize: Int = 30_000,
         pointerLocation: Int = 0,
         cellSize: Int = 256,
         breakOnHash: Bool = false)
    {
        self.cellSize = cellSize
        self.arraySize = arraySize
        array = Array(repeating: 0, count: pointerLocation + 1) + Array(repeating: nil, count: arraySize - 1)
        self.pointerLocation = pointerLocation
        pointer = pointerLocation
        self.endOfInput = endOfInput
        programString = program
        self.program = Program(string: program)
        self.input = input
        self.breakOnHash = breakOnHash
        loops = {
            var array: [Int] = []
            var stack: [Int] = [0]
            var numLoops = 0
            var current = 0
            for instruction in self.program {
                switch instruction {
                    case .conditional:
                        numLoops += 1
                        stack.append(current)
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
        guard program.count > 0 else {
            return .blank
        }
        return program[currentInstructionIndex]
    }
    
    /// The current location of the instruction ``pointer``, minus 1.
    var previousInstructionIndex: Int {
        return currentInstructionIndex - 1
    }
    
    /// The ``Instruction`` that was previously executed.
    var previousInstruction: Instruction {
        guard program.count > 0, previousInstructionIndex > 0 else {
            return .blank
        }
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
    
    private(set) var loops: [Int] = []
    
    /// The maximum size of the ``array``.
    let arraySize: Int
    
    private var array: [Int?]
    
    /// The array used by the program.
    ///
    /// When the interpreter is initialized, the array is completely filled with `nil`s, save for
    /// a single `0` at index `0`. When the pointer moves to a cell that is `nil`, the cell
    /// is automatically set to `0`.
    var cellArray: [Int] {
        array.compactMap { $0 }
    }
    
    /// The amount of non-`nil` cells that are currently in the ``array``.
    private(set) var currentArraySize = 1
    
    /// The pointer used to mark the current cell's location.
    private(set) var pointer = 0
    
    /// The initial location of the pointer.
    private(set) var pointerLocation: Int
    
    /// The contents of the cell the pointer is pointing to.
    var currentCell: Int {
        get {
            if pointer >= 0 && pointer < array.count {
                return array[pointer] ?? 0
            } else {
                return 0
            }
        }
        set {
            array[pointer] = newValue
        }
    }
    
    /// The current cell's value, represeted as an ASCII character.
    var currentCellAsASCII: String {
        asciiValues.indices.contains(currentCell) ? asciiValues[currentCell] : "N/A"
    }
    
    /// The output produced by the program.
    private(set) var output: String = ""
    
    /// The input passed to the program.
    let input: String
    
    /// The amount of times the program has executed the `,` instruction.
    ///
    /// This is used to keep track of the next character that will be passed to the program.
    private(set) var currentInputIndex = 0
    
    /// The character that will be passed to the program upon encountering the `,` instruction.
    ///
    /// This returns `"\0"` if end-of-input has been reached.
    var currentInputCharacter: Character {
        currentInputIndex > input.count - 1 ? Character("\0") : input[input.index(input.startIndex, offsetBy: currentInputIndex)]
    }
    
    /// The current input character, represented as an ASCII character.
    var currentInputCharacterAsASCII: String {
        currentInputIndex > input.count - 1 ? "Null" : asciiValues[Int(currentInputCharacter.asciiValue!)]
    }
    
    /// The total number of instructions that have been executed.
    private(set) var totalInstructionsExecuted = 0
    
    /// Executes an `Instruction`.
    ///
    /// - Parameters:
    ///   - instruction: The `Instruction` to be executed.
    ///
    /// - Throws: `InterpreterError`.
    private func processInstruction(_ instruction: Instruction) throws {
        switch instruction {
            case .moveRight:
                pointer += 1
                if pointer >= array.count {
                    throw InterpreterError.overflow
                } else if array[pointer] == nil {
                    array[pointer] = 0
                    currentArraySize += 1
                }
            case .moveLeft:
                pointer -= 1
                if pointer < 0 { throw InterpreterError.underflow }
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
            case .conditional:
                if currentCell == 0 {
                    currentInstructionIndex = try searchForClosingBracket() // skip the loop
                }
            case .loop:
                if currentCell != 0 {
                    currentInstructionIndex = try searchForOpeningBracket() // restart the loop
                }
            case .output:
                if currentCell < 256 {
                    output.append(Character(UnicodeScalar(UInt8(currentCell))))
                }
            case .input:
                currentCell = if Int(currentInputCharacter.asciiValue ?? 0) == 0 {
                    switch endOfInput {
                        case .noChange:
                            currentCell
                        case .setToZero:
                            0
                        case .setToMax:
                            cellSize - 1
                    }
                } else {
                    Int(currentInputCharacter.asciiValue ?? 0)
                }
                currentInputIndex += 1
            case .break:
                if breakOnHash { throw InterpreterError.break }
            default: break
        }
        totalInstructionsExecuted += 1
    }
    
    /// Runs the program.
    ///
    /// - Throws: `InterpreterError`.
    func run() async throws {
        totalInstructionsExecuted = 0
        currentInstructionIndex = 0
        output = ""
        try checkForMismatchedBrackets()
        while currentInstructionIndex != program.count {
            try processInstruction(currentInstruction)
            currentInstructionIndex += 1
            if Task.isCancelled {
                return
            }
        }
        currentInstructionIndex -= 1
        totalInstructionsExecuted -= 1
    }
    
    /// Steps through the program, one instruction at a time.
    ///
    /// - Throws: `InterpreterError`.
    func step() throws {
        try checkForMismatchedBrackets()
        if currentInstructionIndex != program.count - 1 {
            try processInstruction(currentInstruction)
            currentInstructionIndex += 1
        }
    }
    
    private func checkForMismatchedBrackets() throws {
        let leftBrackets = program.filter { $0 == .conditional }
        let rightBrackets = program.filter { $0 == .loop }
        
        guard leftBrackets.count == rightBrackets.count, loops.last == 0
        else { throw InterpreterError.mismatchedBrackets }
    }
    
    private func searchForClosingBracket() throws -> Int {
        for (index, instruction) in program.enumerated() {
            if instruction == .loop {
                if loops[index] == loops[currentInstructionIndex] {
                    return index
                }
            }
        }
        throw InterpreterError.mismatchedBrackets
    }
    
    private func searchForOpeningBracket() throws -> Int {
        for (index, instruction) in program.enumerated() {
            if instruction == .conditional {
                if loops[index] == loops[currentInstructionIndex] {
                    return index
                }
            }
        }
        throw InterpreterError.mismatchedBrackets
    }
}
