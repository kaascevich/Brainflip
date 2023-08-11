// BrainflipToC+Instructions.swift
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
    @StringBuilder static var moveRightInstruction: String {
        if settings.leftHandIncDec {
            increment
            settings.pointerName
        } else {
            settings.pointerName
            increment
        }
        semicolon
    }

    @StringBuilder static var moveLeftInstruction: String {
        if settings.leftHandIncDec {
            decrement
            settings.pointerName
        } else {
            settings.pointerName
            decrement
        }
        semicolon
    }
    
    @StringBuilder static var incrementInstruction: String {
        if settings.leftHandIncDec {
            increment
            pointerWithNameInParentheses
        } else {
            pointerWithNameInParentheses
            increment
        }
        semicolon
    }

    @StringBuilder static var decrementInstruction: String {
        if settings.leftHandIncDec {
            decrement
            pointerWithNameInParentheses
        } else {
            pointerWithNameInParentheses
            decrement
        }
        semicolon
    }
    
    @StringBuilder static var conditionalInstruction: String {
        Symbols.while
        whitespace(for: .beforeWhileOrIf)
        openingParenthesis
        
        pointerMark(whitespaceBefore: false)
        settings.pointerName
        if settings.includeNotEqualZero {
            surround(Symbols.notEqual, with: .aroundNotEqual)
            Symbols.whileComparisonValue
        }
        
        closingParenthesis
        
        newLineBeforeBrace
        Symbols.openingBrace
    }

    @StringBuilder static var loopInstruction: String {
        Symbols.closingBrace
    }
    
    @StringBuilder static var outputInstruction: String {
        Symbols.outputFuncName
        whitespace(for: .beforeFunctionCall)
        openingParenthesis
        
        pointerWithName
        
        closingParenthesis
        semicolon
    }

    @StringBuilder static var inputInstruction: String {
        if settings.endOfInput == .noChange {
            Symbols.tempVariableName
        } else {
            pointerWithName
        }
        assignment
        Symbols.inputFuncName
        whitespace(for: .beforeFunctionCall)
        Symbols.openingParenthesis
        
        whitespace(for: .inParentheses)
        
        Symbols.closingParenthesis
        semicolon
        if settings.endOfInput == .noChange {
            whitespace(for: .afterSemicolon)
            
            Symbols.if
            whitespace(for: .beforeWhileOrIf)
            openingParenthesis
            
            Symbols.tempVariableName
            surround(Symbols.greaterThanOrEqual, with: .aroundGreaterThanOrEqual)
            Symbols.ifComparisonValue
            
            closingParenthesis
            whitespace(for: .afterIfStatement)
            pointerWithNameInParentheses
            assignment
            Symbols.tempVariableName
            semicolon
        }
    }
    
    /// Exits the program.
    @StringBuilder static var returnInstruction: String {
        Symbols.return
        Symbols.space
        Symbols.returnValue
        semicolon
    }
    
    /// Converts a BF instruction into a line of C code.
    ///
    /// - Parameter type: The type of the instruction.
    ///
    /// - Returns: The converted instruction as a `String`, or `nil`
    ///   if there is no need for the instruction.
    static func createInstruction(type: Instruction) -> String? {
        func cEquivalent(for instruction: Instruction) -> String? {
            switch instruction {
                case .moveRight:   moveRightInstruction
                case .moveLeft:    moveLeftInstruction
                case .increment:   incrementInstruction
                case .decrement:   decrementInstruction
                case .conditional: conditionalInstruction
                case .loop:        loopInstruction
                case .output:      outputInstruction
                case .input:       inputInstruction
                    
                case .break where settings.breakOnHash || settings.includeDisabledBreak:
                    (!settings.breakOnHash ? comment : "") + returnInstruction
                    
                default: nil
            }
        }
        
        // we do want to outdent loop instructions, so this goes first
        if type == .loop {
            indentLevel--
        }
        
        guard let instruction = cEquivalent(for: type) else {
            return nil
        }
        
        // we don't want to indent conditional instructions, so this goes last
        if type == .conditional {
            indentLevel++
        }
        
        return indent + instruction
    }
}
