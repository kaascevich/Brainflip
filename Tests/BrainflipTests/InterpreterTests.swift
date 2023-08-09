// InterpreterTests.swift
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

import XCTest
@testable import Brainflip

final class InterpreterTests: XCTestCase {
    func testBasic() async throws {
        let interpreter = Interpreter(program: "hello ,[>+<-.]", input: "b")
        try await interpreter.run()
        let expectedOutput = (0x00...0x61).reduce("") { current, asciiCode in
            String(Unicode.Scalar(asciiCode)!) + current
        }
        XCTAssertEqual(expectedOutput, interpreter.output)
    }
    
    func testBreak() async throws {
        let interpreter = Interpreter(program: ",[>+#<-.]", input: "b", breakOnHash: true)
        await assertAsyncThrowsError(try await interpreter.run()) { error in
            XCTAssertEqual(error as? InterpreterError, .break)
        }
    }
    
    func testEndOfInput() async throws {
        for endOfInputSetting in Interpreter.EndOfInput.allCases {
            let expectedResult = switch endOfInputSetting {
                case .noChange:  7
                case .setToZero: 0
                case .setToMax:  255
            }
            let interpreter = Interpreter(program: "+++++++,", onEndOfInput: endOfInputSetting)
            try await interpreter.run()
            XCTAssertEqual(interpreter.currentCell, expectedResult)
        }
    }
    
    func testBracketMatching() async throws {
        let invalidPrograms = [
            ",[>+<-.",
            ",[[>+<-.",
            ",][>+<-.",
            ",>+<-.]",
            ",>+<-.]]",
            ",>+<-.][",
            ",[>+<-.][",
            ",[[>+<-.]",
            ",][>+<-.]",
            ",]>+<-.]",
            ",]>+<-.[",
            ",[>+<-.[",
            ",][>+<-.]["
        ]
        
        for invalidProgram in invalidPrograms {
            let interpreter = Interpreter(program: invalidProgram)
            await assertAsyncThrowsError(try await interpreter.run()) { error in
                XCTAssertEqual(error as? InterpreterError, .mismatchedBrackets)
            }
        }
    }
    
    func testArrayBounds() async throws {
        // MARK: Overflow + Array Sizes
        let arraySizes = [30_000, 60_000, 30]
        for arraySize in arraySizes {
            let interpreter = Interpreter(program: "+[>+]", arraySize: arraySize)
            await assertAsyncThrowsError(try await interpreter.run()) { error in
                XCTAssertEqual(error as? InterpreterError, .overflow)
            }
            XCTAssertEqual(interpreter.cellArray.count, arraySize)
            XCTAssert(interpreter.cellArray.allSatisfy { $0 == 1 })
        }
        
        // MARK: Underflow
        let interpreter = Interpreter(program: "<")
        await assertAsyncThrowsError(try await interpreter.run()) { error in
            XCTAssertEqual(error as? InterpreterError, .underflow)
        }
    }
}
