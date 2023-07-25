import SwiftUI

struct Inspector {
    @EnvironmentObject private var settings: AppSettings
                               var state:    ProgramState?
    
    init(state: ProgramState? = nil) {
        self.state = state
        
        typealias ModuleData = (
            name:             String,
            data:             Any?,
            tooltip:          String,
            enabledByDefault: Bool
        )
        
        let moduleData: [ModuleData] = [
            // MARK: Instructions
            
            (
                name:             "Current instruction",
                data:             state?.interpreter.previousInstruction.rawValue,
                tooltip:          "The instruction that has just been executed by the interpreter.",
                enabledByDefault: true
            ), (
                name:             "Current instruction location",
                data:             state?.interpreter.currentInstructionIndex,
                tooltip:          "The location of the current instruction within the program, excluding comments.",
                enabledByDefault: true
            ), (
                name:             "Total instructions executed",
                data:             state?.interpreter.totalInstructionsExecuted,
                tooltip:          "The total number of instructions that have been executed so far.",
                enabledByDefault: true
            ),
            
            // MARK: Pointer
            
            (
                name:             "Pointer location",
                data:             state?.interpreter.pointer,
                tooltip:          "The current location of the pointer.",
                enabledByDefault: true
            ),
            
            // MARK: Cells
            
            (
                name:             "Cell contents",
                data:             state?.interpreter.currentCell,
                tooltip:          "The number stored in the cell currently being pointed at.",
                enabledByDefault: true
            ), (
                name:             "Cell contents (ASCII)",
                data:             state?.interpreter.currentCellAsASCII,
                tooltip:          "The ASCII equivalent of the current cell’s value.",
                enabledByDefault: true
            ),
            
            // MARK: Input
            
            (
                name:             "Current input",
                data:             state?.interpreter.currentInputCharacter,
                tooltip:          "The input character that will be processed upon reaching an input instruction.",
                enabledByDefault: true
            ), (
                name:             "Current input index",
                data:             state?.interpreter.currentInputIndex,
                tooltip:          "The position of the current input character within the input string.",
                enabledByDefault: true
            ),
            
            // MARK: Array
            
            (
                name:             "Array",
                data:             state?.interpreter.cellArray,
                tooltip:          "The entire contents of the array.",
                enabledByDefault: true
            ),
            
            // MARK: Instruction counts
            
            (
                name:             "Pointer movement instructions",
                data:             state?.document.program.instructionCount(.moveLeft, .moveRight),
                tooltip:          "The total amount of pointer movement instructions (< >) within the program.",
                enabledByDefault: false
            ), (
                name:             "Cell manipulation instructions",
                data:             state?.document.program.instructionCount(.increment, .decrement),
                tooltip:          "The total amount of cell manipulation instructions (+ -) within the program.",
                enabledByDefault: false
            ), (
                name:             "Control flow instructions",
                data:             state?.document.program.instructionCount(.conditional, .loop),
                tooltip:          "The total amount of control flow instructions ([ ]) within the program.",
                enabledByDefault: false
            ), (
                name:             "I/O instructions",
                data:             state?.document.program.instructionCount(.output, .input),
                tooltip:          "The total amount of I/O instructions (. ,) within the program.",
                enabledByDefault: false
            ), (
                name:             "Break instructions",
                data:             state?.document.program.instructionCount(.break),
                tooltip:          "The total amount of break instructions (#) within the program.",
                enabledByDefault: false
            )
        ]
        modules = moduleData.map { name, data, tooltip, enabledByDefault in
            Module(
                name,
                data: data,
                tooltip: tooltip,
                enabledByDefault: enabledByDefault
            )
        }
    }
    
    let modules: [Module]
    static let defaultModules: [Bool] = Inspector().modules.map { $0.enabledByDefault }
    static let moduleCount: Int = Inspector().modules.count
}

extension Inspector {
    class Module {
        let name:             String
        var data:             Any?
        let tooltip:          String
        let enabledByDefault: Bool
        
        init(_ name: String,
               data: Any?   = nil,
               tooltip: String = "",
               enabledByDefault: Bool   = true
        ) {
            self.name             = name
            self.data             = data
            self.tooltip          = tooltip
            self.enabledByDefault = enabledByDefault
        }
    }
}
