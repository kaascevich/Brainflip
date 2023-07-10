//
//  Environment.swift
//  Brainflip
//
//  Created by Kaleb on 2/25/23.
//

import Foundation
import UniformTypeIdentifiers
import CodeEditor

class EnvironmentVariables: ObservableObject {
    @Published var interpreter = Interpreter(program: "\0", onEndOfInput: .noChange, arraySize: 30_000)
    @Published var program = ""
    @Published var output = ""
    @Published var input = ""
    @Published var showingHelp = false
    @Published var runningProgram = false
    @Published var errorDescription = ""
    @Published var hasError = false
    @Published var justRanProgram = false
    @Published var readableTypes: [UTType] = [.plainText, .brainflipSource]
    @Published var isExportingFile = false
    @Published var isSavingFile = false
    @Published var isImportingFile = false
    @Published var isClearAlertShowing = false
    @Published var filePath: URL? = nil
    @Published var selection: Range<String.Index> = "".endIndex..<"".endIndex
    @Published var theme: CodeEditor.ThemeName = .default
    @Published var execution = Task() { }
    
    @Published var endOfInput = Interpreter.EndOfInput(rawValue: UserDefaults.standard.string(forKey: "endOfInput") ?? Interpreter.EndOfInput.noChange.rawValue) ?? .noChange {
        didSet {
            UserDefaults.standard.set(endOfInput.rawValue, forKey: "endOfInput")
            interpreter.endOfInput = endOfInput
            reset()
        }
    }
    @Published var arraySize = Double(UserDefaults.standard.integer(forKey: "arraySize")) {
        didSet {
            UserDefaults.standard.set(arraySize, forKey: "arraySize")
            interpreter = Interpreter(program: program, onEndOfInput: endOfInput, arraySize: Int(arraySize))
        }
    }

    func processError(_ error: Error) {
        switch error {
        case InterpreterError.mismatchedBrackets:
            errorDescription = "There are unmatched brackets within your code."
        case InterpreterError.underflow:
            errorDescription = "An attempt was made to go below the bounds of the array."
        case InterpreterError.overflow:
            errorDescription = "An attempt was made to go above the bounds of the array."
        default:
            errorDescription = "An unknown error occured."
        }
        hasError = true
    }
    
    @MainActor
    func run() {
        if interpreter.program != Program(program: program) {
            interpreter = Interpreter(program: program, onEndOfInput: endOfInput, arraySize: Int(arraySize))
        }
        execution = Task {
            do {
                runningProgram = true
                var newInterpreter = Interpreter(program: program, onEndOfInput: endOfInput, arraySize: Int(arraySize))
                output = ""
                selection = "".endIndex..<"".endIndex
                interpreter = newInterpreter
                output = try await newInterpreter.run(input)
                runningProgram = false
                justRanProgram = true
                return
            } catch {
                processError(error)
            }
        }
    }
    
    @MainActor
    func step() {
        Task {
            do {
                var newInterpreter: Interpreter
                if justRanProgram
                    || interpreter.input != input
                    || interpreter.programString != program {
                    newInterpreter = Interpreter(program: program, onEndOfInput: endOfInput, arraySize: Int(arraySize))
                    justRanProgram = false
                } else {
                    newInterpreter = interpreter
                }
                interpreter = newInterpreter
                
                output = try await newInterpreter.step(input)
                
                let commentedProgramCount = newInterpreter.commentCharacters[newInterpreter.previousInstructionIndex]
                
                let startIndex = String.Index(utf16Offset: newInterpreter.previousInstructionIndex + commentedProgramCount, in: program)
                let endIndex = program.index(after: startIndex)
                selection = startIndex..<endIndex
            } catch {
                processError(error)
            }
        }
    }
    
    @MainActor
    func clearAll() {
        Task {
            execution.cancel()
            selection = "".endIndex..<"".endIndex
            program = ""
            input = ""
            output = ""
            interpreter = Interpreter(program: program, onEndOfInput: endOfInput, arraySize: Int(arraySize))
            runningProgram = false
            justRanProgram = false
        }
    }
    
    func reset() {
        execution.cancel()
        if interpreter.currentInstructionIndex != 0 {
            selection = "".endIndex..<"".endIndex
        }
        interpreter = Interpreter(program: program, onEndOfInput: endOfInput, arraySize: Int(arraySize))
        output = ""
        runningProgram = false
        justRanProgram = false
    }
}
