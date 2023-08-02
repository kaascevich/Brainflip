import Foundation

/// Errors that can be thrown by the Brainflip interpreter.
enum InterpreterError: Error, Equatable {
    /// Thrown when the interpreter finds unmatched brackets.
    case mismatchedBrackets(leftBracketCount: Int, rightBracketCount: Int)
    
    /// Thrown when the pointer points to a cell that is below the bounds of the array.
    case underflow(location: Int)
    
    /// Thrown when the pointer points to a cell that is above the bounds of the array.
    case overflow(location: Int)
    
    /// Thrown when encountering a break instruction (if enabled).
    case `break`
}
