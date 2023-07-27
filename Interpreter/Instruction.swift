import Foundation

/// Instructions that can be executed by the Brainflip interpreter.
public enum Instruction: Character, CaseIterable {
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
    public static var validInstructions: String {
        String(allCases.filter { $0 != .blank }.map(\.rawValue))
    }
}
