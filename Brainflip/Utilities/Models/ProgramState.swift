import SwiftUI
import Combine

@MainActor
final class ProgramState: ObservableObject {
    @State private var settings = AppSettings()
    
    @Published var document: ProgramDocument
    init(document: ProgramDocument) {
        self.document = document
    }
    
    @Published var isShowingOutput = true
    @Published var isShowingInspector = true
    @Published var interpreter = Interpreter(program: "\0")
    @Published var output = ""
    @Published var input = ""
    @Published var isRunningProgram = false
    @Published var justRanProgram = false
    @Published var isSteppingThrough = false
    @Published var errorDescription = ""
    @Published var hasError = false
    @Published var isClearAlertShowing = false
    @Published var isWarningAboutTrim = false
    @Published var isAskingForOutputFile = false
    @Published var showingMainHelp = false
    @Published var selection: Range<Int> = 0..<0
    @Published var timeElapsed = TimeInterval(0)
    @Published var startDate = Date()
    @Published var timer: Publishers.Autoconnect<Timer.TimerPublisher>?
    @Published var execution = Task { }
    private func processError(_ error: Error) {
        switch error {
            case InterpreterError.mismatchedBrackets:
                errorDescription = "There are unmatched brackets within your code."
            case InterpreterError.underflow:
                errorDescription = "An attempt was made to go below the bounds of the array."
                updateSelection()
            case InterpreterError.overflow:
                errorDescription = "An attempt was made to go above the bounds of the array."
                updateSelection()
            case InterpreterError.break:
                stop()
                errorDescription = ""
            default:
                errorDescription = "An unknown error occured."
                updateSelection()
        }
        hasError = true
    }
    
    func run()  {
        timeElapsed = TimeInterval(0)
        startDate = Date()
        timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
        justRanProgram = false
        execution = Task {
            isRunningProgram = true
            if settings.playSounds && settings.playStartSound {
                SystemSounds.purr.play()
            }
            interpreter = createInterpreter()
            output = ""
            selection = 0..<0
            do {
                try await interpreter.run()
                if settings.playSounds && settings.playSuccessSound {
                    SystemSounds.glass.play()
                }
            } catch {
                processError(error)
                if !errorDescription.isEmpty {
                    execution.cancel()
                    if settings.playSounds && settings.playFailSound {
                        SystemSounds.sosumi.play()
                    }
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
        isRunningProgram || document.contents.isEmpty
    }
    
    func step() {
        if shouldReset() {
            reset()
        }
        justRanProgram = false
        isSteppingThrough = true
        do {
            try interpreter.step()
            if settings.playSounds && settings.playStepSound {
                SystemSounds.pop.play()
            }
            output = interpreter.output
            updateSelection()
        } catch {
            NSApp.requestUserAttention(.informationalRequest)
            processError(error)
            if !errorDescription.isEmpty {
                if settings.playSounds && settings.playFailSound {
                    SystemSounds.sosumi.play()
                }
            }
        }
        isSteppingThrough = false
    }
    var disableStepButton: Bool {
        (interpreter.currentInstruction == .blank
            && interpreter.currentInstructionIndex != 0)
            || document.contents.isEmpty || isRunningProgram
    }
    
    private func updateSelection() {
        if !settings.showCurrentInstruction { return }
        if interpreter.previousInstructionIndex < interpreter.commentCharacters.count && interpreter.previousInstructionIndex >= 0 {
            let commentCountAtCurrentInstruction = interpreter.commentCharacters[interpreter.previousInstructionIndex]
            let startIndex = interpreter.previousInstructionIndex + commentCountAtCurrentInstruction
            let endIndex = startIndex + 1
            selection = startIndex..<endIndex
        }
    }
    
    func clearAll() {
        timeElapsed = TimeInterval(0)
        execution.cancel()
        selection = 0..<0 
        document.contents = ""
        input = ""
        output = ""
        interpreter = createInterpreter()
        isRunningProgram = false
        justRanProgram = false
    }
    
    func reset() {
        timeElapsed = TimeInterval(0)
        execution.cancel()
        if interpreter.currentInstructionIndex != 0 {
            selection = 0..<0
        }
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
        return !isRunningProgram
    }
    
    private func createInterpreter() -> Interpreter {
        Interpreter(program: document.contents,
                    input: input,
                    onEndOfInput: settings.endOfInput,
                    arraySize: Int(settings.arraySize),
                    pointerLocation: Int(settings.pointerLocation),
                    cellSize: settings.cellSize.rawValue,
                    breakOnHash: settings.breakOnHash)
    }
    
    private func shouldReset() -> Bool {
        settings.endOfInput != interpreter.endOfInput
            || Int(settings.arraySize) != interpreter.arraySize
            || Int(settings.pointerLocation) != interpreter.pointerLocation
            || settings.cellSize.rawValue != interpreter.cellSize
            || interpreter.program != Program(string: document.contents)
            || justRanProgram
    }
}
