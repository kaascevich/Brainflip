import Foundation

extension BrainflipToC {
    // MARK: - Newlines
    
    @StringBuilder static var newLineBeforeBrace: String {
        if settings.openingBraceOnNewLine {
            Symbols.newline
            indent
        } else {
            whitespace(for: .beforeBrace)
        }
    }
    
    // MARK: - Increment & Decrement
    
    @StringBuilder static var increment: String {
        if settings.leftHandIncDec {
            Symbols.increment
            whitespace(for: .aroundIncDec)
        } else {
            whitespace(for: .aroundIncDec)
            Symbols.increment
        }
    }
    @StringBuilder static var decrement: String {
        if settings.leftHandIncDec {
            Symbols.decrement
            whitespace(for: .aroundIncDec)
        } else {
            whitespace(for: .aroundIncDec)
            Symbols.decrement
        }
    }
    
    // MARK: - Parentheses & Brackets
    
    @StringBuilder static var openingParenthesis: String {
        Symbols.openingParenthesis
        whitespace(for: .inParentheses)
    }
    @StringBuilder static var closingParenthesis: String {
        whitespace(for: .inParentheses)
        Symbols.closingParenthesis
    }
    
    @StringBuilder static var openingBracket: String {
        Symbols.openingBracket
        whitespace(for: .inBrackets)
    }
    @StringBuilder static var closingBracket: String {
        whitespace(for: .inBrackets)
        Symbols.closingBracket
    }
    
    // MARK: - Pointers
    
    @StringBuilder static var pointerCast: String {
        if cellType == Symbols.char { "" } else {
            openingParenthesis
            Symbols.char
            pointerMark(whitespaceAfter: false)
            closingParenthesis
        }
    }
    @StringBuilder static var pointerWithName: String {
        pointerMark(whitespaceBefore: false, whitespaceAfter: settings.leftHandIncDec)
        settings.pointerName
    }
    @StringBuilder static var pointerWithNameInParentheses: String {
        openingParenthesis
        pointerWithName
        closingParenthesis
    }
    
    // MARK: - Assignment
    
    @StringBuilder static var assignment: String {
        surround(Symbols.assignment, with: .aroundAssignment)
    }
    @StringBuilder static var compoundAssignment: String {
        surround(Symbols.compoundAssignment, with: .aroundCompoundAssignment)
    }
    
    // MARK: - Other
    
    @StringBuilder static var semicolon: String {
        whitespace(for: .beforeSemicolon)
        Symbols.semicolon
    }
    @StringBuilder static var comma: String {
        surround(Symbols.comma, before: .beforeCommas, after: .afterCommas)
    }
    
    @StringBuilder static var comment: String {
        Symbols.comment
        whitespace(for: .afterCommentMarkers)
    }
    
    static var cellType: String {
        switch settings.cellSize {
            case .eightBit:     // 255
                Symbols.char
            case .sixteenBit:   // 65,635
                Symbols.short
            case .thirtyTwoBit: // 4,294,967,295
                Symbols.int
            default:            // 1, 3, 15 -> 255
                Symbols.char    // since the smallest type in C is char
        }
    }
}
