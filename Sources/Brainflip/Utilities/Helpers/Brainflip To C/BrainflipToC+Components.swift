// BrainflipToC+Components.swift
// Copyright © 2023 Kaleb A. Ascevich
//
// This app is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This app is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
// for more details.
//
// You should have received a copy of the GNU General Public License along
// with this app. If not, see https://www.gnu.org/licenses/.

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
    
    /// The semicolon required after every statement.
    @StringBuilder static var semicolon: String {
        whitespace(for: .beforeSemicolon)
        Symbols.semicolon
    }
    
    @StringBuilder static var comment: String {
        Symbols.comment
        whitespace(for: .afterCommentMarkers)
    }
    
    /// A `String` representation of the cell size.
    static var cellType: String {
        switch settings.cellSize {
            case .eightBit:     Symbols.char  // 255
            case .sixteenBit:   Symbols.short // 65,635
            case .thirtyTwoBit: Symbols.int   // 4,294,967,295
            default:            Symbols.char  // 255 (since the smallest type in C is char)
        }
    }
}
