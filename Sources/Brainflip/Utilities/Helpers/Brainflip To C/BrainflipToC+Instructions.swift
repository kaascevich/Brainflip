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
            increment + settings.pointerName
        } else {
            settings.pointerName + increment
        }
        semicolon
    }

    @StringBuilder static var moveLeftInstruction: String {
        if settings.leftHandIncDec {
            decrement + settings.pointerName
        } else {
            settings.pointerName + decrement
        }
        semicolon
    }
    
    @StringBuilder static var incrementInstruction: String {
        if settings.leftHandIncDec {
            increment + inParentheses { pointerWithName }
        } else {
            inParentheses { pointerWithName } + increment
        }
        semicolon
    }

    @StringBuilder static var decrementInstruction: String {
        if settings.leftHandIncDec {
            decrement + inParentheses { pointerWithName }
        } else {
            inParentheses { pointerWithName } + decrement
        }
        semicolon
    }
    
    @StringBuilder static var conditionalInstruction: String {
        "while" + whitespace(for: .beforeWhileOrIf)
        
        inParentheses {
            pointerMark(whitespaceBefore: false)
            settings.pointerName
            if settings.includeNotEqualZero {
                surround("!=", with: .aroundNotEqual) + "0"
            }
        }
        
        openingBrace
    }
    
    @StringBuilder static var outputInstruction: String {
        "putchar" + whitespace(for: .beforeFunctionCall)
        inParentheses { pointerWithName }
        semicolon
    }

    @StringBuilder static var inputInstruction: String {
        settings.endOfInput == .noChange ? "i" : pointerWithName
        surround("=", with: .aroundAssignment)
        "getchar" + whitespace(for: .beforeFunctionCall)
        
        "(" + whitespace(for: .inParentheses) + ")"
        semicolon
        
        if settings.endOfInput == .noChange {
            whitespace(for: .afterSemicolon)
            
            "if" + whitespace(for: .beforeWhileOrIf)
            inParentheses {
                "i" + surround(">=", with: .aroundGreaterThanOrEqual) + "0"
            }
            whitespace(for: .afterIfStatement)
            
            inParentheses { pointerWithName }
            surround("=", with: .aroundAssignment)
            "i"
            semicolon
        }
    }
    
    /// Exits the program.
    @StringBuilder static var returnInstruction: String {
        "return 0" + semicolon
    }
    
    /// Converts a BF instruction into a line of C code.
    ///
    /// - Parameter type: The type of the instruction.
    ///
    /// - Returns: The converted instruction as a `String`, or `nil`
    ///   if there is no need for the instruction.
    static func createInstruction(type: Instruction) -> String? {
        // swiftlint:disable:next cyclomatic_complexity
        func cEquivalent(for instruction: Instruction) -> String? {
            switch instruction {
                case .moveRight:   moveRightInstruction
                case .moveLeft:    moveLeftInstruction
                case .increment:   incrementInstruction
                case .decrement:   decrementInstruction
                case .conditional: conditionalInstruction
                case .loop:        "}"
                case .output:      outputInstruction
                case .input:       inputInstruction
                    
                case .break where settings.breakOnHash:
                    returnInstruction
                
                // If we get here then breakOnHash is disabled
                case .break where settings.includeDisabledBreak:
                    "//" + whitespace(for: .afterCommentMarkers) + returnInstruction
                    
                default: nil
            }
        }
        
        // we do want to outdent loop instructions, so this goes first
        if type == .loop {
            indentLevel -= 1
        }
        
        guard let instruction = cEquivalent(for: type) else {
            return nil
        }
        let indentedInstruction = indent + instruction
        
        // we don't want to indent conditional instructions, so this goes last
        if type == .conditional {
            indentLevel += 1
        }
        
        return indentedInstruction
    }
}
