import SwiftUI
import Combine
import Observation

// MARK: - Properties
@Observable final class AppState {
    var document: BrainflipDocument
    init(document: BrainflipDocument) {
        self.document = document
    }
    
    var convertedDocument: CSourceDocument? = nil
    
    var isShowingOutput: Bool = true
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
    var errorType: InterpreterError? = nil
    var hasError: Bool = false
    
    var selection: Range<Int> = 0..<0
    
    var timeElapsed: TimeInterval = 0
    var startDate: Date = .now
    var timer: Publishers.Autoconnect<Timer.TimerPublisher>? = nil
    
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
                if settings.playSounds, settings.playSuccessSound { SystemSounds.success.play() }
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
                    if errorType != .break {
                    }
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
        if settings.showCurrentInstruction,
           interpreter.previousInstructionIndex < interpreter.commentCharacters.count,
           interpreter.previousInstructionIndex >= 0
        {
            let commentCountAtCurrentInstruction = interpreter.commentCharacters[interpreter.previousInstructionIndex]
            let startIndex = interpreter.previousInstructionIndex + commentCountAtCurrentInstruction
            let endIndex = startIndex + 1
            selection = startIndex..<endIndex
        }
    }
    
    func clearAll() {
        execution.cancel()
        timeElapsed       = TimeInterval(0)
        selection         = 0..<0
        document.contents = ""
        input             = ""
        output            = ""
        interpreter       = createInterpreter()
        isRunningProgram  = false
        justRanProgram    = false
    }
    
    func reset() {
        execution.cancel()
        if interpreter.currentInstructionIndex != 0 { selection = 0..<0 }
        timeElapsed      = TimeInterval(0)
        interpreter      = createInterpreter()
        output           = ""
        isRunningProgram = false
        justRanProgram   = false
    }
    var disableResetButton: Bool {
        (isRunningProgram || interpreter.currentInstructionIndex == 0)
            && !justRanProgram
    }

    func stop() {
        execution.cancel()
        updateSelection()
        output           = interpreter.output
        isRunningProgram = false
        justRanProgram   = false
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
        Interpreter(program:         document.contents,
                    input:           input,
                    onEndOfInput:    settings.endOfInput,
                    arraySize:       Int(settings.arraySize),
                    pointerLocation: Int(settings.pointerLocation),
                    cellSize:        settings.cellSize.rawValue,
                    breakOnHash:     settings.breakOnHash
        )
    }
    
    private func shouldReset() -> Bool {
           settings.endOfInput           != interpreter.endOfInput
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
            isConversionProgressShowing = true
            try await Task.sleep(nanoseconds: 1)
            convertedDocument = CSourceDocument(try! BrainflipToC.convertToC(document.program))
            isConversionProgressShowing = false
            isAskingForOutputFile.toggle()
        }
    }
}

// MARK: - Error Handling
@Observable extension AppState {
    private func processError(_ error: Error) {
        errorType = error as? InterpreterError
        
        errorDescription = message(for: error)
        
        switch error {
            case InterpreterError.mismatchedBrackets: break
            case InterpreterError.break: stop()
            default: updateSelection()
        }
        
        if error as? InterpreterError != .break {
            hasError = true
            if settings.playSounds, settings.playFailSound { SystemSounds.fail.play() }
        }
    }
    
    private func message<T: Error>(for error: T) -> String {
        let ordinalFormatter = NumberFormatter()
        ordinalFormatter.numberStyle = .ordinal
        
        switch error {
            case let error as InterpreterError: switch error {
                case .mismatchedBrackets(let leftBracketCount, let rightBracketCount):
                    // If the bracket counts are equal, there isn't really a point in echoing them.
                    let firstSentence = "There are unmatched brackets within your code."
                    guard leftBracketCount != rightBracketCount else {
                        return firstSentence
                    }
                    
                    // Get the difference in bracket amounts
                    let extraBracketCount = abs(leftBracketCount - rightBracketCount)
                    
                    // Check whether we have more left brackets than right brackets, or vice versa
                    let extraBracketType = leftBracketCount > rightBracketCount ? "left" : "right"
                    
                    let secondSentence = "You have \(extraBracketCount) extra \(extraBracketType) \(extraBracketCount == 1 ? "bracket" : "brackets")."
                    
                    return firstSentence + " " + secondSentence
                    
                case .underflow(let location):
                    return """
                    An attempt was made to go below the bounds of the array. It happened at the \(ordinalFormatter.string(from: location + 1 as NSNumber)!) instruction.
                    
                    (Hint: try raising the initial pointer location in the interpreter settings.)
                    """
                    
                case .overflow(let location):
                    return """
                    An attempt was made to go above the bounds of the array. It happened at the \(ordinalFormatter.string(from: location + 1 as NSNumber)!) instruction.
                    
                    (Hint: try increasing the array size or lowering the intiial pointer location in the interpreter settings.)
                    """
                    
                case .break: return "" // we're not going to show the message anyway
            }
                
            case let error as LocalizedError:
                return "Error description: \(error.localizedDescription)"
                
            case let error as CustomStringConvertible:
                return "Error description: \(error.description)"
                
            default:
                return "An unknown error occured. (Sorry for not being more helpful, we really don't know what went wrong.)"
        }
    }
}
