// Inspector.swift
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

import os.log
import SwiftUI

struct Inspector {
    @EnvironmentObject private var settings: AppSettings
    var interpreter: Interpreter?
    
    init(interpreter: Interpreter? = nil) {
        self.interpreter = interpreter
        
        modules = [
            Module(
                "Current instruction",
                data: interpreter?.previousInstruction.rawValue,
                tooltip: "The instruction that has just been executed by the interpreter."
            ),
            Module(
                "Current instruction location",
                data: interpreter?.previousInstructionIndex,
                tooltip: "The location of the current instruction within the program, excluding comments."
            ),
            Module(
                "Total instructions executed",
                data: interpreter?.totalInstructionsExecuted,
                tooltip: "The total number of instructions that have been executed so far."
            ),
            
            // MARK: Pointer
            
            Module(
                "Pointer location",
                data: interpreter?.pointer,
                tooltip: "The current location of the pointer."
            ),
            
            // MARK: Cells
            
            Module(
                "Cell contents",
                data: interpreter?.currentCell,
                tooltip: "The number stored in the cell currently being pointed at."
            ),
            Module(
                "Cell contents (ASCII)",
                data: interpreter?.currentCellAsASCII,
                tooltip: "The ASCII equivalent of the current cell’s value."
            ),
            
            // MARK: Input
            
            Module(
                "Current input",
                data: interpreter?.currentInputCharacter,
                tooltip: "The input character that will be processed upon reaching an input instruction."
            ),
            Module(
                "Current input index",
                data: interpreter?.currentInputIndex,
                tooltip: "The position of the current input character within the input string."
            ),
            
            // MARK: Array
            
            Module(
                "Array",
                data: interpreter?.cellArray,
                tooltip: "The entire contents of the array."
            ),
            
            // MARK: Instruction counts
            
            Module(
                "Pointer movement instructions",
                data: interpreter?.totalPointerMovementInstructionsExecuted,
                tooltip: "The total amount of pointer movement instructions (<>) that have been executed so far.",
                enabledByDefault: false
            ),
            Module(
                "Cell manipulation instructions",
                data: interpreter?.totalCellValueInstructionsExecuted,
                tooltip: "The total amount of cell manipulation instructions (+-) that have been executed so far.",
                enabledByDefault: false
            ),
            Module(
                "Control flow instructions",
                data: interpreter?.totalControlFlowInstructionsExecuted,
                tooltip: "The total amount of control flow instructions ([]) that have been executed so far.",
                enabledByDefault: false
            ),
            Module(
                "I/O instructions",
                data: interpreter?.totalIOInstructionsExecuted,
                tooltip: "The total amount of I/O instructions (.,) that have been executed so far.",
                enabledByDefault: false
            )
        ]
    }
    
    let modules: [Module]
    
    static let staticInspector = Self()
}

extension Inspector {
    struct Module {
        let name: String
        var data: Any?
        let tooltip: String
        let enabledByDefault: Bool
        
        init(_ name: String, data: Any? = nil, tooltip: String, enabledByDefault: Bool = true) {
            self.name = name
            self.data = data
            self.tooltip = tooltip
            self.enabledByDefault = enabledByDefault
        }
    }
}
