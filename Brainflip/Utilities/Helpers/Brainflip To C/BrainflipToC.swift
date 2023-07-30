import Foundation
import RegexBuilder
import os.log

enum BrainflipToC {
    static let logger = Logger(subsystem: bundleID, category: "Brainflip-to-C conversion")
        
    /// A `Regex` matching valid C identifiers.
    ///
    /// This regex is equivalent to `/[_a-zA-Z]\w{0,30}/`.
    ///
    /// Identifiers in C can begin with an underscore or a letter.
    /// After the first character, numbers can be used as well.
    static let identifierRegex = Regex {
        CharacterClass(
            .anyOf("_"),
            ("a"..."z"),
            ("A"..."Z")
        )
        Repeat(0...30) {
            One(.word)
        }
    }
    
    static func convertToC(_ program: Program) throws -> String {
        // Quick check to make sure all loops are closed -- we can't convert an invalid program
        try Interpreter(program: program).checkForMismatchedBrackets()
        
        indentLevel = 0
        var converted = header
        indentLevel = 1

        converted += program.compactMap(createInstruction).map { $0 + Symbols.newline }.reduce("", +)
        converted += indent + returnInstruction + Symbols.newline
        converted += Symbols.closingBrace
        
        return converted
    }
}
