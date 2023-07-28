import Foundation

public extension Interpreter {
    /// Errors that can be thrown by the interpreter.
    enum Error: String, Swift.Error {
        /// Thrown when the interpreter finds unmatched brackets.
        case mismatchedBrackets = "There are unmatched brackets within your code."
        
        /// Thrown when the pointer points to a cell that is below the bounds of the array.
        case underflow = "An attempt was made to go below the bounds of the array. \n\n(Hint: try raising the initial pointer location in the interpreter settings.)"
        
        /// Thrown when the pointer points to a cell that is above the bounds of the array.
        case overflow = "An attempt was made to go above the bounds of the array. \n\n(Hint: try increasing the array size or lowering the intiial pointer location in the interpreter settings.)"
        
        /// Thrown when encountering a break instruction (if enabled).
        case `break` = ""
    }
}
