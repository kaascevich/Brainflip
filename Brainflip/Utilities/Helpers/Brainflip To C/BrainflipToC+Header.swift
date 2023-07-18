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
    
    @StringBuilder static var includeStatement: String {
        Symbols.include
        Symbols.space
        Symbols.openingAngleBracket
        Symbols.includedLibrary
        Symbols.closingAngleBracket
    }
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
    @StringBuilder static var initialPointerLocation: String {
        settings.pointerName
        compoundAssignment
        String(Int(settings.pointerLocation))
        semicolon
        
        Symbols.newline
    }
}
