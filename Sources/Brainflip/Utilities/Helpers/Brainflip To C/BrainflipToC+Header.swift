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

extension BrainflipToC {
    @StringBuilder static var header: String {
        """
        #include <stdio.h>
        \(arrayDeclaration)
        \(pointerDeclaration)
        \(tempVariableDeclaration)
        \(main)
        """
    }
    
    /// The declaration of the array.
    @StringBuilder static var arrayDeclaration: String {
        "unsigned \(cellType) \(settings.arrayName)"
        
        whitespace(for: .beforeBrackets)
        "[" + surround(String(Int(settings.arraySize)), with: .inBrackets) + "]"
        semicolon
    }
    
    /// The declaration of the pointer.
    @StringBuilder static var pointerDeclaration: String {
        "unsigned \(cellType)\(pointerMark())"
        settings.pointerName
        surround("=", with: .aroundAssignment)
        settings.arrayName
        if settings.pointerLocation != 0 {
            surround("+", with: .aroundAddition)
            String(Int(settings.pointerLocation))
        }
        semicolon
    }
    
    /// The declaration of the temporary variable used for I/O, if necessary.
    @StringBuilder static var tempVariableDeclaration: String {
        if settings.endOfInput == .noChange {
            "\(cellType) i"
            surround("=", with: .aroundAssignment)
            "0"
            semicolon
        }
    }
    
    /// The declaration of the `main()` function.
    @StringBuilder static var main: String {
        "int main" + whitespace(for: .beforeFunctionCall)
        
        if settings.includeVoidWithinMain {
            inParentheses { "void" }
        } else {
            "(" + whitespace(for: .inParentheses) + ")"
        }
        
        openingBrace
    }
}
