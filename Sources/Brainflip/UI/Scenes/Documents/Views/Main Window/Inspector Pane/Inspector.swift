import SwiftUI
import os.log

struct Inspector {
    @EnvironmentObject private var settings: AppSettings
    var interpreter: Interpreter?
    
    init(interpreter: Interpreter? = nil) {
        self.interpreter = interpreter
        
        modules = [
            Module(
                name:             "Current instruction",
                data:             interpreter?.previousInstruction.rawValue,
                tooltip:          "The instruction that has just been executed by the interpreter.",
                enabledByDefault: true
            ), Module(
                name:             "Current instruction location",
                data:             interpreter?.previousInstructionIndex,
                tooltip:          "The location of the current instruction within the program, excluding comments.",
                enabledByDefault: true
            ), Module(
                name:             "Total instructions executed",
                data:             interpreter?.totalInstructionsExecuted,
                tooltip:          "The total number of instructions that have been executed so far.",
                enabledByDefault: true
            ),
            
            // MARK: Pointer
            
            Module(
                name:             "Pointer location",
                data:             interpreter?.pointer,
                tooltip:          "The current location of the pointer.",
                enabledByDefault: true
            ),
            
            // MARK: Cells
            
            Module(
                name:             "Cell contents",
                data:             interpreter?.currentCell,
                tooltip:          "The number stored in the cell currently being pointed at.",
                enabledByDefault: true
            ), Module(
                name:             "Cell contents (ASCII)",
                data:             interpreter?.currentCellAsASCII,
                tooltip:          "The ASCII equivalent of the current cell’s value.",
                enabledByDefault: true
            ),
            
            // MARK: Input
            
            Module(
                name:             "Current input",
                data:             interpreter?.currentInputCharacter,
                tooltip:          "The input character that will be processed upon reaching an input instruction.",
                enabledByDefault: true
            ), Module(
                name:             "Current input index",
                data:             interpreter?.currentInputIndex,
                tooltip:          "The position of the current input character within the input string.",
                enabledByDefault: true
            ),
            
            // MARK: Array
            
            Module(
                name:             "Array",
                data:             interpreter?.cellArray,
                tooltip:          "The entire contents of the array.",
                enabledByDefault: true
            ),
            
            // MARK: Instruction counts
            
            Module(
                name:             "Pointer movement instructions",
                data:             interpreter?.totalPointerMovementInstructionsExecuted,
                tooltip:          "The total amount of pointer movement instructions (<>) that have been executed so far.",
                enabledByDefault: false
            ), Module(
                name:             "Cell manipulation instructions",
                data:             interpreter?.totalCellManipulationInstructionsExecuted,
                tooltip:          "The total amount of cell manipulation instructions (+-) that have been executed so far.",
                enabledByDefault: false
            ), Module(
                name:             "Control flow instructions",
                data:             interpreter?.totalControlFlowInstructionsExecuted,
                tooltip:          "The total amount of control flow instructions ([]) that have been executed so far.",
                enabledByDefault: false
            ), Module(
                name:             "I/O instructions",
                data:             interpreter?.totalIOInstructionsExecuted,
                tooltip:          "The total amount of I/O instructions (.,) that have been executed so far.",
                enabledByDefault: false
            )
        ]
    }
    
    let modules: [Module]
    
    static let staticInspector = Inspector()
}

extension Inspector {
    struct Module {
        let name:             String
        var data:             Any?
        let tooltip:          String
        let enabledByDefault: Bool
    }
}
