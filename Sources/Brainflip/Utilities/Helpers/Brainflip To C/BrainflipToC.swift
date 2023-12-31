// BrainflipToC.swift
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

import RegexBuilder

enum BrainflipToC {
    /// A `Regex` matching valid C identifiers.
    ///
    /// This regex is equivalent to `/[_a-zA-Z]\w{0,30}/`.
    ///
    /// Identifiers in C can begin with an underscore or a letter.
    /// After the first character, numbers can be used as well.
    static let identifierRegex = Regex {
        CharacterClass(
            .anyOf("_"),
            "a"..."z",
            "A"..."Z"
        )
        // .word is equivalent to /\w/ or /[_a-zA-Z0-9]/
        Repeat(.word, 0...30)
    }
    
    static func convertToC(_ program: Program) throws -> String {
        // Quick check to make sure all loops are closed -- we can't convert an invalid program
        try Interpreter(program: program).checkForMismatchedBrackets()
        
        indentLevel = 1

        return program
            .compactMap(createInstruction)
            .reduce(header + "\n") { $0 + $1 + "\n" }
            .appending(indent + returnInstruction + "\n")
            .appending("}")
    }
}
