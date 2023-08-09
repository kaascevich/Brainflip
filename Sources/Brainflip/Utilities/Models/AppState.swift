// AppState.swift
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

import Combine
import Observation
import SwiftUI

// MARK: - Properties

@Observable final class AppState {
    var document: BrainflipDocument
    init(document: BrainflipDocument, isLocked: Bool = false) {
        self.document = document
        self.isLocked = isLocked
    }
    
    /// Whether or not the document is locked.
    let isLocked: Bool
    
    var convertedDocument: CSourceDocument?
    
    /// Whether or not the output pane is shown.
    var isShowingOutput: Bool = true
    
    /// Whether or not the inspector pane is shown.
    var isShowingInspector: Bool = true {
        willSet { updateInspector() }
    }
    
    var isClearAlertShowing: Bool = false
    var isWarningAboutTrim: Bool = false
    var isInformingAboutCExport: Bool = false
    var isAskingForOutputFile: Bool = false
    var isConversionProgressShowing: Bool = false
    var showingArray: Bool = false
    var showingMainHelp: Bool = false
    
    var interpreter: Interpreter = .init(program: "\0")
    var output: String = ""
    var input: String = ""
    
    var execution: Task = .init { }
    deinit { execution.cancel() }
    
    var errorDescription: String = ""
    
    /// An InterpreterError instance if error is an InterpreterError;
    /// otherwise, nil.
    var errorType: InterpreterError?
    var hasError: Bool = false
    
    var selection: Range<Int> = 0..<0
    
    var timeElapsed: TimeInterval = 0
    var startDate: Date = .now
    var timer: Publishers.Autoconnect<Timer.TimerPublisher>?
    
    var inspector: Inspector = .init(interpreter: .init(program: "\0"))
    
    var justRanProgram: Bool = false
    var isRunningProgram: Bool = false
    var isSteppingThrough: Bool = false
}

// MARK: - Methods

@Observable extension AppState {
    @MainActor
    func run() {
        if isValidKonamiCode(document.contents) {
            document.contents = "That ain't gonna fly here"
        }
        
        timeElapsed = TimeInterval(0)
        startDate = Date()
        timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
        justRanProgram = false
        
        execution = Task {
            interpreter = createInterpreter()
            isRunningProgram = true
            if settings.playSounds, settings.playStartSound { SystemSounds.start.play() }
            output = ""
            selection = 0..<0
            do {
                try await interpreter.run()
                if !Task.isCancelled, settings.playSounds, settings.playSuccessSound { SystemSounds.success.play() }
                Notifications.sendNotification(document.filename)
            } catch {
                processError(error)
                if errorType != .break {
                    Notifications.sendNotification(document.filename, error: error)
                    execution.cancel()
                    if settings.playSounds, settings.playFailSound { SystemSounds.fail.play() }
                }
            }
            NSApp.requestUserAttention(.informationalRequest)
            updateInspector()
            output = interpreter.output
            isRunningProgram = false
            justRanProgram = true
            timer?.upstream.connect().cancel(); timer = nil
        }
    }

    var disableRunButton: Bool {
        isRunningProgram || document.program.count <= 1
    }
    
    @MainActor
    func step() {
        if !isSteppingThrough {
            if shouldReset() { reset() }
            justRanProgram = false
            isSteppingThrough = true
            Task {
                do {
                    try interpreter.step()
                    if settings.playSounds, settings.playStepSound { SystemSounds.step.play() }
                    output = interpreter.output
                    updateSelection()
                } catch {
                    processError(error)
                }
                updateInspector()
                isSteppingThrough = false
            }
        }
    }

    var disableStepButton: Bool {
        (interpreter.currentInstruction == .blank
            && interpreter.currentInstructionIndex != 0)
            || isRunningProgram
            || document.program.count <= 1
    }
    
    private func updateSelection() {
        /// An array of `Int`s that stores the total number of comment characters encountered so far.
        ///
        /// One can think of this as the difference between `string.count` and
        /// `Program(from: string).count`, where
        /// `string == programString[0..<index]`.
        func commentCharacters(in string: String) -> [Int] {
            var array: [Int] = []
            var numCommentCharacters = 0
            for character in string {
                if Instruction.validInstructions.contains(character) {
                    array.append(numCommentCharacters)
                } else {
                    numCommentCharacters += 1
                }
            }
            return array
        }
        
        if settings.showCurrentInstruction,
           interpreter.previousInstructionIndex < commentCharacters(in: document.contents).count,
           interpreter.previousInstructionIndex >= 0
        {
            let commentCountAtCurrentInstruction = commentCharacters(in: document.contents)[interpreter.previousInstructionIndex]
            let startIndex = interpreter.previousInstructionIndex + commentCountAtCurrentInstruction
            let endIndex = startIndex + 1
            selection = startIndex..<endIndex
        }
    }
    
    func clearAll() {
        reset()
        document.contents = ""
        input = ""
    }
    
    func reset() {
        execution.cancel()
        selection = 0..<0
        timeElapsed = TimeInterval(0)
        interpreter = createInterpreter()
        output = ""
        isRunningProgram = false
        justRanProgram = false
    }

    var disableResetButton: Bool {
        (isRunningProgram || interpreter.currentInstructionIndex == 0)
            && !justRanProgram
    }

    func stop() {
        execution.cancel()
        updateSelection()
        output = interpreter.output
        isRunningProgram = false
        justRanProgram = false
    }

    var disableStopButton: Bool { !isRunningProgram }
    
    var disableMenuItems: Bool {
        isAskingForOutputFile
            || isInformingAboutCExport
            || isWarningAboutTrim
            || isClearAlertShowing
            || isConversionProgressShowing
            || hasError
            || showingMainHelp
    }
    
    private func createInterpreter() -> Interpreter {
        Interpreter(
            program:         document.contents,
            input:           input,
            onEndOfInput:    settings.endOfInput,
            arraySize:       Int(settings.arraySize),
            pointerLocation: Int(settings.pointerLocation),
            cellSize:        settings.cellSize.rawValue,
            breakOnHash:     settings.breakOnHash
        )
    }
    
    private func shouldReset() -> Bool {
        settings.endOfInput                  != interpreter.endOfInput
            || Int(settings.arraySize)       != interpreter.arraySize
            || Int(settings.pointerLocation) != interpreter.pointerLocation
            || settings.cellSize.rawValue    != interpreter.cellSize
            || interpreter.program           != Program(string: document.contents)
            || justRanProgram
    }
    
    private func updateInspector() {
        if isShowingInspector {
            inspector = .init(interpreter: interpreter)
        }
    }
    
    @MainActor
    func exportToC() {
        Task {
            // This should never be nil if we're disabling the export button correctly.
            if (try? Interpreter(program: document.program).checkForMismatchedBrackets()) != nil {
                isConversionProgressShowing = true
                try await Task.sleep(nanoseconds: 1) // Needed to show the progress sheet. Why? I dunno.
                
                // swiftlint:disable:next force_try
                convertedDocument = CSourceDocument(try! BrainflipToC.convertToC(document.program))
                
                isConversionProgressShowing = false
                isAskingForOutputFile.toggle()
            }
        }
    }
}

// MARK: - Error Handling

@Observable extension AppState {
    private func processError(_ error: Error) {
        errorType = error as? InterpreterError
        errorDescription = message(for: error)
        
        // Don't bother calling updateSelection() since mismatched brackets
        // are found before the program runs.
        if errorType != .mismatchedBrackets {
            updateSelection()
        }
        
        // No need to show an error message on a break.
        if errorType != .break {
            hasError = true
            if settings.playSounds, settings.playFailSound { SystemSounds.fail.play() }
        } else {
            stop()
        }
    }
    
    private func message(for error: some Error) -> String {
        switch error {
        case let error as InterpreterError: message(forInterpreterError: error)
        case let error as LocalizedError: "Error description: \(error.localizedDescription)"
        case let error as CustomStringConvertible: "Error description: \(error.description)"
        default: "An unknown error occured. (Sorry for not being more helpful, we really don't know what went wrong.)"
        }
    }
    
    private func message(forInterpreterError error: InterpreterError) -> String {
        switch error {
        case .mismatchedBrackets:
            let leftBracketCount  = document.program.count(of: .conditional)
            let rightBracketCount = document.program.count(of: .loop)
            
            // If the bracket counts are equal, there isn't really a point in echoing them.
            let firstSentence = "There are unmatched brackets within your code."
            guard leftBracketCount != rightBracketCount else {
                return firstSentence
            }
            
            // Get the difference in bracket amounts.
            let extraBracketCount = abs(leftBracketCount - rightBracketCount)
            
            // Check whether we have more left brackets than right brackets, or vice versa.
            let extraBracketType = leftBracketCount > rightBracketCount ? "left" : "right"
            
            let secondSentence = "You have \(extraBracketCount) extra \(extraBracketType) \(extraBracketCount == 1 ? "bracket" : "brackets")."
            
            return firstSentence + " " + secondSentence
            
        case .underflow, .overflow:
            let ordinalFormatter = NumberFormatter()
            ordinalFormatter.numberStyle = .ordinal
            
            // string(from:) returns an optional for very obscure reasons; it's fine to force-unwrap
            let errorLocation = ordinalFormatter.string(from: interpreter.previousInstructionIndex + 1 as NSNumber)!
            
            let (spillDirection, hintMessage) = if error == .overflow {
                ("above", "increasing the array size")
            } else {
                ("below", "raising the initial pointer location")
            }
            
            return """
            An attempt was made to go \(spillDirection) the bounds of the array. It happened at the \(errorLocation) instruction.
            
            (Hint: try \(hintMessage) in the interpreter settings.)
            """
            
        case .break: return "" // We're not going to show the message anyway.
        }
    }
}
