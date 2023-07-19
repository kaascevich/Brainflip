import SwiftUI
import Combine

@MainActor
final class ProgramState: ObservableObject {
    @Published var document: ProgramDocument
    init(document: ProgramDocument, filename: String = "") {
        self.document = document
        self.filename = filename
    }
    
    @Published var convertedDocument: CSourceDocument? = nil
    @Published var filename: String = ""
    @Published var isShowingOutput: Bool = true
    @Published var isShowingInspector: Bool = true
    @Published var interpreter: Interpreter = .init(program: "\0")
    @Published var output: String = ""
    @Published var input: String = ""
    @Published var isRunningProgram: Bool = false
    @Published var justRanProgram: Bool = false
    @Published var isSteppingThrough: Bool = false
    @Published var errorDescription: String = ""
    @Published var errorType: InterpreterError? = nil
    @Published var hasError: Bool = false
    @Published var isClearAlertShowing: Bool = false
    @Published var isWarningAboutTrim: Bool = false
    @Published var isInformingAboutCExport: Bool = false
    @Published var isAskingForOutputFile: Bool = false
    @Published var isConversionProgressShowing: Bool = false
    @Published var showingArray: Bool = false
    @Published var showingMainHelp: Bool = false
    @Published var selection: Range<Int> = 0..<0
    @Published var timeElapsed: TimeInterval = 0
    @Published var startDate: Date = .now
    @Published var timer: Publishers.Autoconnect<Timer.TimerPublisher>? = nil
    @Published var execution: Task = .init { }
    
    private func processError(_ error: Error) {
        errorType = error as? InterpreterError
        
        errorDescription = switch error {
            case let error as InterpreterError: error.rawValue
            default: "An unknown error occured. (Sorry for not being more helpful, we really don't know what went wrong.)"
        }
        
        switch error {
            case InterpreterError.mismatchedBrackets: break
            case InterpreterError.break: stop()
            default: updateSelection()
        }
        
        if error is InterpreterError, error as! InterpreterError != .break {
            hasError = true
        }
    }
    
    func run()  {
        if isValidKonamiCode(document.contents) {
            document.contents = "Ha ha‚ nice try․"
        }
        
        timeElapsed    = TimeInterval(0)
        startDate      = Date()
        timer          = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
        justRanProgram = false
        
        execution = Task {
            isRunningProgram = true
            if settings.playSounds, settings.playStartSound { SystemSounds.start.play() }
            interpreter = createInterpreter()
            output      = ""
            selection   = 0..<0
            do {
                try await interpreter.run()
                if settings.playSounds, settings.playSuccessSound { SystemSounds.success.play() }
                Notifications.sendNotification(filename)
            } catch {
                processError(error)
                if !errorDescription.isEmpty {
                    Notifications.sendNotification(filename, error: error)
                    execution.cancel()
                    if settings.playSounds, settings.playFailSound { SystemSounds.fail.play() }
                }
            }
            NSApp.requestUserAttention(.informationalRequest)
            output = interpreter.output
            isRunningProgram = false
            justRanProgram = true
            timer!.upstream.connect().cancel()
            timer = nil
        }
    }
    var disableRunButton: Bool {
        isRunningProgram
    }
    
    func step() {
        if shouldReset() {
            reset()
        }
        justRanProgram = false
        isSteppingThrough = true
        Task {
            do {
                try await interpreter.step()
                if settings.playSounds, settings.playStepSound { SystemSounds.step.play() }
                output = interpreter.output
                updateSelection()
            } catch {
                NSApp.requestUserAttention(.informationalRequest)
                processError(error)
                if !errorDescription.isEmpty {
                    if settings.playSounds, settings.playFailSound { SystemSounds.fail.play() }
                }
            }
            isSteppingThrough = false
        }
    }
    var disableStepButton: Bool {
        (interpreter.currentInstruction == .blank
            && interpreter.currentInstructionIndex != 0)
            || isRunningProgram
    }
    
    private func updateSelection() {
        if settings.showCurrentInstruction,
           interpreter.previousInstructionIndex < interpreter.commentCharacters.count,
           interpreter.previousInstructionIndex >= 0
        {
            let commentCountAtCurrentInstruction = interpreter.commentCharacters[interpreter.previousInstructionIndex]
            let startIndex                       = interpreter.previousInstructionIndex + commentCountAtCurrentInstruction
            let endIndex                         = startIndex + 1
                selection                        = startIndex..<endIndex
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
