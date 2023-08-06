// BrainflipToC+Header.swift
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

import Foundation

extension BrainflipToC {
    @StringBuilder static var header: String {
        includeStatement;        Symbols.newline
        arrayDeclaration;        Symbols.newline
        pointerDeclaration;      Symbols.newline
        tempVariableDeclaration; Symbols.newline
        main;                    Symbols.newline
        if settings.pointerLocation != 0 {
            baseIndent; initialPointerLocation
        }
    }
    
    /// The `#include` statement.
    ///
    /// This statement is necessary to perform I/O.
    @StringBuilder static var includeStatement: String {
        Symbols.include
        Symbols.space
        Symbols.openingAngleBracket
        Symbols.includedLibrary
        Symbols.closingAngleBracket
    }
    
    /// The declaration of the array.
    @StringBuilder static var arrayDeclaration: String {
        Symbols.unsigned
        Symbols.space
        cellType
        Symbols.space
        settings.arrayName
        whitespace(for: .beforeBrackets)
        openingBracket
        String(Int(settings.arraySize))
        closingBracket
        semicolon
    }
    
    /// The declaration of the pointer.
    @StringBuilder static var pointerDeclaration: String {
        Symbols.unsigned
        Symbols.space
        cellType
        pointerMark()
        settings.pointerName
        `assignment`
        settings.arrayName
        semicolon
    }
    
    /// The declaration of the temporary variable used for I/O, if necessary.
    @StringBuilder static var tempVariableDeclaration: String {
        if settings.endOfInput == .noChange {
            cellType
            Symbols.space
            Symbols.tempVariableName
            `assignment`
            Symbols.tempVariableValue
            semicolon
        }
    }
    
    /// The declaration of the `main()` function.
    @StringBuilder static var main: String {
        Symbols.mainReturnType
        Symbols.space
        Symbols.main
        whitespace(for: .beforeFunctionCall)
        if settings.includeVoidWithinMain {
            openingParenthesis
            Symbols.mainArguments
            closingParenthesis
        } else {
            Symbols.openingParenthesis
            whitespace(for: .inParentheses)
            Symbols.closingParenthesis
        }
        
        newLineBeforeBrace
        Symbols.openingBrace
    }
    
    /// The line that sets the pointer to its initial value, if necessary.
    @StringBuilder static var initialPointerLocation: String {
        settings.pointerName
        compoundAssignment
        String(Int(settings.pointerLocation))
        semicolon
        
        Symbols.newline
    }
}
