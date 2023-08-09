// RunBFProgramIntent.swift
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

import AppIntents

struct RunBFProgramIntent: AppIntent {
    static let title: LocalizedStringResource = "Run Brainflip Program"
    static let description = IntentDescription(
        """
        Runs a Brainflip program using the specified interpreter settings, giving it the provided input. Returns the program's output.
        """,
        searchKeywords: [
            "brainflip",
            "brainfuck",
            "bf",
            "run",
            "execute",
            "program",
            "code"
        ]
    )
    
    @Parameter(
        title: "Program",
        description: "The program to execute.",
        inputOptions: .init(
            keyboardType: .numbersAndPunctuation,
            capitalizationType: .none,
            multiline: true,
            autocorrect: false,
            smartQuotes: false,
            smartDashes: false
        ),
        requestValueDialog: "What program should be run?"
    ) var program: String
    
    @Parameter(
        title: "Input",
        description: "The input to provide to the program.",
        inputOptions: .init(
            capitalizationType: .none,
            autocorrect: false,
            smartQuotes: false,
            smartDashes: false
        ),
        requestValueDialog: "What should the program recieve as input?"
    ) var input: String
    
    @Parameter(
        title: "End-of-Input Action",
        description: "The action to take when there is no input left.",
        default: .noChange,
        requestValueDialog: "What should happen when there's no input left?"
    ) var endOfInput: Interpreter.EndOfInput
    
    @Parameter(
        title: "Array Size",
        description: "The size of the array.",
        default: 30_000,
        controlStyle: .stepper,
        inclusiveRange: (30_000, 60_000),
        requestValueDialog: "What should the array size be?"
    ) var arraySize: Int
    
    @Parameter(
        title: "Initial Pointer Location",
        description: "The initial location of the pointer.",
        default: 0,
        controlStyle: .stepper,
        inclusiveRange: (0, 100),
        requestValueDialog: "On which cell should the pointer start?"
    ) var pointerLocation: Int
    
    @Parameter(
        title: "Cell Size",
        description: "The size of the array's cells.",
        default: .eightBit,
        requestValueDialog: "How big should the cells be?"
    ) var cellSize: CellSize
    
    @Parameter(
        title: "Stop on Break Instruction",
        description: "Whether to stop the program when encountering a hash (#).",
        default: false,
        requestValueDialog: "Should the program stop when encountering a hash?"
    ) var breakOnHash: Bool
    
    func perform() async throws -> some IntentResult & ReturnsValue<String> {
        let interpreter = Interpreter(
            program:         program,
            input:           input,
            onEndOfInput:    endOfInput,
            arraySize:       arraySize,
            pointerLocation: pointerLocation,
            cellSize:        cellSize.rawValue,
            breakOnHash:     breakOnHash
        )
        
        do {
            try await interpreter.run()
        } catch let error as InterpreterError {
            let errorDescription = switch error {
                case .mismatchedBrackets: "There are mismatched brackets within the program."
                case .overflow:           "An attempt was made to go above the array bounds."
                case .underflow:          "An attempt was made to go below the array bounds."
                case .break:              "A hash was encountered."
            }
            throw IntentError(errorDescription)
        }
        
        return .result(value: interpreter.output)
    }
}

struct IntentError: Error, CustomStringConvertible {
    var description: String
    
    init(_ description: String) {
        self.description = description
    }
}
