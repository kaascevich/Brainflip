import Foundation
import RegexBuilder

enum BrainflipToC {
    static var settings = AppSettings()
    
    // Equivalent to /[_a-zA-Z]\w{0,30}/
    // Identifiers in C can begin with an underscore or a letter
    // After the first character numbers can be used as well
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
    
    static func convertToC(_ program: Program) -> String {
        // Quick check to make sure all loops are closed -- we can't convert an invalid program
        guard Interpreter(program: program).loops.last == 0 else { return "" }
        
        indentLevel = 0
        var converted = header
        indentLevel = 1
        
        for instruction in program {
            if let instruction = createInstruction(type: instruction) {
                converted += instruction + Symbols.newline
            }
        }
        converted += indent + returnInstruction + Symbols.newline
        converted += Symbols.closingBrace
        return converted
    }
}
