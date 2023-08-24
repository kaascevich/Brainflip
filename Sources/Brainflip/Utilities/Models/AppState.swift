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
    var isShowingOutput = true
    
    /// Whether or not the inspector pane is shown.
    var isShowingInspector = true
    
    var isClearAlertShowing = false
    var isWarningAboutTrim = false
    var isInformingAboutCExport = false
    var isAskingForOutputFile = false
    var isConversionProgressShowing = false
    var showingArray = false
    var showingMainHelp = false
    
    var interpreter = Interpreter(program: "\0")
    var output = ""
    var input = ""
    
    var execution = Task { }
    deinit {
        execution.cancel()
    }
    
    var errorDescription = ""
    
    /// An InterpreterError instance if error is an InterpreterError;
    /// otherwise, nil.
    var errorType: InterpreterError?
    var hasError = false
    
    var selection = 0..<0
    
    var timeElapsed = TimeInterval.zero
    var startDate = Date.now
    var timer: Publishers.Autoconnect<Timer.TimerPublisher>?
        
    var justRanProgram = false
    var isRunningProgram = false
    var isSteppingThrough = false
}

// MARK: - Methods

// @Observable
extension AppState {
    @MainActor func run() {
        if isValidKonamiCode(document.contents) {
            document.contents = "That ain't gonna fly here"
        }
        
        reset()
        isRunningProgram = true
        timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
        
        execution = Task {
            SystemSounds.start.playIfEnabled()
            
            do {
                try await interpreter.run()
                if !Task.isCancelled {
                    SystemSounds.success.playIfEnabled()
                }
                Notifications.sendNotification(document.filename)
            } catch {
                processError(error)
            }
            NSApplication.shared.requestUserAttention(.informationalRequest)
            output = interpreter.output
            isRunningProgram = false
            justRanProgram = true
            timer?.upstream.connect().cancel(); timer = nil
        }
    }

    var disableRunButton: Bool {
        isRunningProgram || document.program.count <= 1
    }
    
    @MainActor func step() {
        guard !isSteppingThrough else {
            return
        }
        
        if shouldReset {
            reset()
        }
        justRanProgram = false
        isSteppingThrough = true
        Task {
            do {
                try interpreter.step()
                SystemSounds.step.playIfEnabled()
                output = interpreter.output
                updateSelection()
            } catch {
                processError(error)
            }
            isSteppingThrough = false
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
        
        guard settings.showCurrentInstruction,
              interpreter.previousInstructionIndex < commentCharacters(in: document.contents).count,
              interpreter.previousInstructionIndex >= 0
        else {
            return
        }
        
        let commentCountAtCurrentInstruction = commentCharacters(in: document.contents)[interpreter.previousInstructionIndex]
        let startIndex = interpreter.previousInstructionIndex + commentCountAtCurrentInstruction
        let endIndex = startIndex + 1
        selection = startIndex..<endIndex
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
        startDate = Date()
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

    var disableStopButton: Bool {
        !isRunningProgram
    }
    
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
    
    private var shouldReset: Bool {
        settings.endOfInput              != interpreter.endOfInput
        || Int(settings.arraySize)       != interpreter.arraySize
        || Int(settings.pointerLocation) != interpreter.pointerLocation
        || settings.cellSize.rawValue    != interpreter.cellSize
        || document.program              != interpreter.program
        || justRanProgram
    }
    
    @MainActor
    func exportToC() {
        Task {
            defer {
                isConversionProgressShowing = false
            }
            
            do {
                // This should never throw if we're disabling the export button correctly.
                try Interpreter(program: document.program).checkForMismatchedBrackets()
                
                isConversionProgressShowing = true
                try await Task.sleep(nanoseconds: 1) // Needed to show the progress sheet. Why? I dunno.
                
                // This should never throw at all, ever, if we're still here after
                // the previous check, but I want to make the linter happy.
                let convertedProgram = try BrainflipToC.convertToC(document.program)
                convertedDocument = CSourceDocument(convertedProgram)
                
                isAskingForOutputFile.toggle()
            }
        }
    }
}

// MARK: - Error Handling

extension AppState {
    private func processError(_ error: Error) {
        let interpreterError = error as? InterpreterError
        errorDescription = message(for: error)
        
        // Don't bother calling updateSelection() since mismatched brackets
        // are found before the program runs.
        if interpreterError != .mismatchedBrackets {
            updateSelection()
        }
        
        // No need to show an error message on a break. We do want to update
        // the selection, though, so this check is after that.
        guard interpreterError != .break else {
            stop()
            return
        }
        
        hasError = true
        execution.cancel()
        
        Notifications.sendNotification(document.filename, error: error)
        SystemSounds.fail.playIfEnabled()
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
                let ordinalFormatter = NumberFormatter().then {
                    $0.numberStyle = .ordinal
                }
                
                let errorLocation = interpreter.previousInstructionIndex + 1 as NSNumber
                
                // string(from:) returns an optional for very obscure reasons; it's fine to force-unwrap
                let formattedErrorLocation = ordinalFormatter.string(from: errorLocation)!
                
                let (spillDirection, hintMessage) = if error == .overflow {
                    ("above", "increasing the array size")
                } else {
                    ("below", "raising the initial pointer location")
                }
                
                return """
                An attempt was made to go \(spillDirection) the bounds of the array. It happened at the \(formattedErrorLocation) instruction.
                
                (Hint: try \(hintMessage) in the interpreter settings.)
                """
                
            case .break: return "" // We're not going to show the message anyway.
        }
    }
}
