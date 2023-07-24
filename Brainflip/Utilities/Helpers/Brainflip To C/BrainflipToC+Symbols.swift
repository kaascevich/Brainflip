import Foundation

extension BrainflipToC {
    /// An enumeration of the symbols used to translate BF into C.
    ///
    /// - Remark: I've used `static let`s instead of `case`s because I'd
    ///   otherwise have to specify `.rawValue` every time.
    enum Symbols {

        // MARK: - Whitespace
        
        static let newline              = "\n"
        static let space                = " "
        
        // MARK: - Groupings
        
        static let openingParenthesis   = "("
        static let closingParenthesis   = ")"
        static let openingBracket       = "["
        static let closingBracket       = "]"
        static let openingBrace         = "{"
        static let closingBrace         = "}"
        static let openingAngleBracket  = "<"
        static let closingAngleBracket  = ">"
        
        // MARK: - Assignment
        
        static let assignment           = "="
        static let compoundAssignment   = "+="
        
        // MARK: - Operators
        
        static let increment            = "++"
        static let decrement            = "--"
        
        // MARK: - Types
        
        static let unsigned             = "unsigned"
        static let char                 = "char"
        static let short                = "short"
        static let int                  = "int"
        
        // MARK: - While
        
        static let `while`              = "while"
        static let notEqual             = "!="
        static let whileComparisonValue = "0"
        
        // MARK: - If
        
        static let `if`                 = "if"
        static let greaterThanOrEqual   = ">="
        static let ifComparisonValue    = "0"
        
        // MARK: - Punctuation
        
        static let comma                = ","
        static let semicolon            = ";"
        static let pointer              = "*"
        
        // MARK: - Return
        
        static let `return`             = "return"
        static let returnValue          = "0"
        
        // MARK: - Include
        
        static let include              = "#include"
        static let includedLibrary      = "stdio.h"
         
        // MARK: - Output
         
        static let outputFuncName       = "putchar"
         
        // MARK: - Input
         
        static let inputFuncName        = "getchar"
         
        // MARK: - Main
         
        static let main                 = "main"
        static let mainReturnType       = "int"
        static let mainArguments        = "void"
         
        // MARK: - Comments
         
        static let comment              = "//"
        
        // MARK: - Temp Variable
        
        static let tempVariableName     = "i"
        static let tempVariableValue    = "0"
    }
}
