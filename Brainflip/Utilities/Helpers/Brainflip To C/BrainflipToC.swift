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
        logger.info("Conversion started on program \"\(program.description)\"")
        
        // Quick check to make sure all loops are closed -- we can't convert an invalid program
        guard Interpreter(program: program).loops.last == 0 else {
            logger.error("Error: invalid program \"\(program.description)\"; cannot continue")
            throw InterpreterError.mismatchedBrackets
        }
        
        logger.log("Generating header")
        indentLevel = 0
        var converted = header
        indentLevel = 1
        logger.log("Header generation complete, result: \"\(converted)\"")
        
        for instruction in program {
            if let convertedInstruction = createInstruction(type: instruction) {
                logger.log("Converted instruction \"\(instruction.rawValue)\", result: \"\(convertedInstruction)\"")
                converted += convertedInstruction + Symbols.newline
            }
        }
        converted += indent + returnInstruction + Symbols.newline
        converted += Symbols.closingBrace
        
        logger.info("Conversion complete, result: \"\(converted)\"")
        return converted
    }
}
