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

enum Inspector {
    struct Module {
        let name: String
        var data: KeyPath<Interpreter, String>
        let tooltip: String
        let enabledByDefault: Bool
    }
    
    static let modules = [
        Module(
            name: "Current instruction",
            data: \.previousInstruction.rawValue.description,
            tooltip: "The instruction that has just been executed by the interpreter.",
            enabledByDefault: true
        ),
        Module(
            name: "Current instruction location",
            data: \.previousInstructionIndex.description,
            tooltip: "The location of the current instruction within the program, excluding comments.",
            enabledByDefault: true
        ),
        Module(
            name: "Total instructions executed",
            data: \.totalInstructionsExecuted.description,
            tooltip: "The total number of instructions that have been executed so far.",
            enabledByDefault: true
        ),
        
        // MARK: Pointer
        
        Module(
            name: "Pointer location",
            data: \.pointer.description,
            tooltip: "The current location of the pointer.",
            enabledByDefault: true
        ),
        
        // MARK: Cells
        
        Module(
            name: "Cell contents",
            data: \.currentCell.description,
            tooltip: "The number stored in the cell currently being pointed at.",
            enabledByDefault: true
        ),
        Module(
            name: "Cell contents (ASCII)",
            data: \.currentCellAsASCII,
            tooltip: "The ASCII equivalent of the current cell’s value.",
            enabledByDefault: true
        ),
        
        // MARK: Input
        
        Module(
            name: "Current input",
            data: \.currentInputCharacter.description,
            tooltip: "The input character that will be processed upon reaching an input instruction.",
            enabledByDefault: true
        ),
        Module(
            name: "Current input index",
            data: \.currentInputIndex.description,
            tooltip: "The position of the current input character within the input string.",
            enabledByDefault: true
        ),
        
        // MARK: Array
        
        Module(
            name: "Array",
            data: \.cellArray.description,
            tooltip: "The entire contents of the array.",
            enabledByDefault: true
        ),
        
        // MARK: Instruction counts
        
        Module(
            name: "Pointer movement instructions",
            data: \.totalPointerMovementInstructionsExecuted.description,
            tooltip: "The total amount of pointer movement instructions (<>) that have been executed so far.",
            enabledByDefault: false
        ),
        Module(
            name: "Cell manipulation instructions",
            data: \.totalCellValueInstructionsExecuted.description,
            tooltip: "The total amount of cell manipulation instructions (+-) that have been executed so far.",
            enabledByDefault: false
        ),
        Module(
            name: "Control flow instructions",
            data: \.totalControlFlowInstructionsExecuted.description,
            tooltip: "The total amount of control flow instructions ([]) that have been executed so far.",
            enabledByDefault: false
        ),
        Module(
            name: "I/O instructions",
            data: \.totalIOInstructionsExecuted.description,
            tooltip: "The total amount of I/O instructions (.,) that have been executed so far.",
            enabledByDefault: false
        )
    ]
}
