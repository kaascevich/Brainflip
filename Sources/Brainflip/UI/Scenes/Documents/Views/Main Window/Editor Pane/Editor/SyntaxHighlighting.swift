// SyntaxHighlighting.swift
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

import SwiftUI
import HighlightedTextEditor

// These properties all need to be computed in order to refresh the views.
struct SyntaxHighlighting {
    static var hashColor: Color {
        settings.breakOnHash ? .green : .gray
    }
    static var highlightPatterns: [(String, Color)] {
        [
            ("[<>]",     .orange),   // "<>"
            ("[+-]",     .red),      // "+-"
            (#"[\[\]]"#, .brown),    // "[]"
            ("[\\.,]",   .purple),   // ".,"
            ("#",         hashColor) // "#"
        ]
    }
    
    static var highlightRules: [HighlightRule] {
        highlightPatterns.map { (regex, color) in
            HighlightRule(
                pattern: try! NSRegularExpression(pattern: regex),
                formattingRule: TextFormattingRule(
                    key: .foregroundColor,
                    value: NSColor(color)
                )
            )
        }
    }
}
