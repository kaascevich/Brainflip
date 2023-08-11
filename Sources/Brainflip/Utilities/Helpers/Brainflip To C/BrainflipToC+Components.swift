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
    
    @StringBuilder static var openingBrace: String {
        if settings.openingBraceOnNewLine {
            "\n" + indent
        } else {
            whitespace(for: .beforeBrace)
        }
        "{"
    }
    
    // MARK: - Increment & Decrement
    
    @StringBuilder static var increment: String {
        if settings.leftHandIncDec {
            "++" + whitespace(for: .aroundIncDec)
        } else {
            whitespace(for: .aroundIncDec) + "++"
        }
    }

    @StringBuilder static var decrement: String {
        if settings.leftHandIncDec {
            "--" + whitespace(for: .aroundIncDec)
        } else {
            whitespace(for: .aroundIncDec) + "--"
        }
    }
    
    // MARK: - Parentheses
    
    @StringBuilder static func inParentheses(@StringBuilder string: () -> String) -> String {
        "(" + surround(string(), with: .inParentheses) + ")"
    }
    
    // MARK: - Pointers

    @StringBuilder static var pointerWithName: String {
        pointerMark(whitespaceBefore: false, whitespaceAfter: settings.leftHandIncDec)
        settings.pointerName
    }
    
    // MARK: - Other
    
    /// The semicolon required after every statement.
    @StringBuilder static var semicolon: String {
        whitespace(for: .beforeSemicolon) + ";"
    }
    
    /// A `String` representation of the cell size.
    static var cellType: String {
        switch settings.cellSize {
            case .eightBit:     "char"  // 255
            case .sixteenBit:   "short" // 65,635
            case .thirtyTwoBit: "int"   // 4,294,967,295
            default:            "char"  // 255 (since the smallest type in C is char)
        }
    }
}
