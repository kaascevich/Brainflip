// InterpreterUITests.swift
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

import Flow
import XCTest

final class InterpreterUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.do {
            $0.launchArguments += ["-ApplePersistenceIgnoreState", "YES"]
            $0.launchArguments += ["--ui-testing"]
            $0.launch()
        }
    }
    
    /// Outputs every ASCII character below the input.
    let simpleTestProgram = ",[>+<-.]"
    
    // MARK: - Tests
    
    func testBasic() throws {
        // MARK: Setup
        
        app.typeKey("n", modifierFlags: .command) // Creates a new document
        
        let documentWindow = app.windows["Untitled"]
        XCTAssert(documentWindow.waitForExistence(timeout: 3))
        
        let editor = documentWindow.textViews["Editor"]
        let input = documentWindow.textFields["Input"]
        let output = documentWindow.scrollViews["Output"].textViews.firstMatch
        let runButton = documentWindow.buttons["run-button-main"]
        
        let inputText = "b"
        let inputASCIICode = Character(inputText).asciiValue!
        
        // MARK: Running
        
        editor.do {
            $0.click()
            $0.typeText(simpleTestProgram)
        }
        input.do {
            $0.click()
            $0.typeText(inputText)
        }

        runButton.click()
        
        // Swift won't let us store invisible ASCII characters in strings.
        // So we need to put it together manually.
        let expectedOutput = String(
            (0...inputASCIICode - 1)
                .map { String(Unicode.Scalar($0)) }
                .reduce("", +)
                .reversed()
        )
        
        Thread.sleep(forTimeInterval: 0.5) // give the program some time to run
        XCTAssertEqual(expectedOutput, output.value as? String)
    }
    
    func testBracketMatching() throws {
        // MARK: Setup
        
        app.typeKey("n", modifierFlags: .command) // Creates a new document
        
        let documentWindow = app.windows["Untitled"]
        XCTAssert(documentWindow.waitForExistence(timeout: 3))
        
        let editor = documentWindow.textViews["Editor"]
        let runButton = documentWindow.buttons["run-button-main"]
        let alertSheet = documentWindow.sheets["alert"]
        let okButton = alertSheet.buttons["action-button-1"]
        
        let invalidPrograms = Array([
            ",[>+<-.":    "There are unmatched brackets within your code. You have 1 extra left bracket.",
            ",[[>+<-.":   "There are unmatched brackets within your code. You have 2 extra left brackets.",
            ",][>+<-.":   "There are unmatched brackets within your code.",
            ",>+<-.]":    "There are unmatched brackets within your code. You have 1 extra right bracket.",
            ",>+<-.]]":   "There are unmatched brackets within your code. You have 2 extra right brackets.",
            ",>+<-.][":   "There are unmatched brackets within your code.",
            ",[>+<-.][":  "There are unmatched brackets within your code. You have 1 extra left bracket.",
            ",[[>+<-.]":  "There are unmatched brackets within your code. You have 1 extra left bracket.",
            ",][>+<-.]":  "There are unmatched brackets within your code. You have 1 extra right bracket.",
            ",]>+<-.]":   "There are unmatched brackets within your code. You have 2 extra right brackets.",
            ",]>+<-.[":   "There are unmatched brackets within your code.",
            ",[>+<-.[":   "There are unmatched brackets within your code. You have 2 extra left brackets.",
            ",][>+<-.][": "There are unmatched brackets within your code."
        ])
        
        // MARK: Testing
        
        for (program, expectedErrorMessage) in invalidPrograms {
            editor.do {
                $0.click()
                $0.typeText(program)
            }
            runButton.click()
            
            alertSheet.do {
                XCTAssert($0.waitForExistence(timeout: 0.5)) // Confirm there is an error...
                XCTAssert($0.staticTexts[expectedErrorMessage].exists) // ...and that the message is correct
                okButton.click()
            }
            
            // Clear all text
            editor.do {
                $0.click()
                $0.typeKey("a", modifierFlags: .command) // Select all
                $0.typeKey(.delete, modifierFlags: [])
            }
        }
    }
    
    func testBreak() throws {
        // MARK: Setup
        
        let menuBar = app.menuBars.firstMatch
        app.typeKey("n", modifierFlags: .command) // Creates a new document
        
        let documentWindow = app.windows["Untitled"]
        XCTAssert(documentWindow.waitForExistence(timeout: 3))
        
        let editor = documentWindow.textViews["Editor"]
        let output = documentWindow.scrollViews["Output"].textViews.firstMatch
        let runButton = documentWindow.buttons["run-button-main"]
        
        let alertSheet = documentWindow.sheets["alert"]
        
        // MARK: Initial Test
        
        editor.do {
            $0.click()
            $0.typeText("++++++[>++++++<-]>..........") // Prints 10 dollar signs "$$$$$$$$$$"
        }
        runButton.click()
        XCTAssertEqual("$$$$$$$$$$", output.value as? String) // Confirm that it works normally...
        XCTAssertFalse(alertSheet.exists) // ...and that there is no error
        
        // MARK: Adding a Break Instruction
        
        editor.do {
            $0.click()
            $0.typeKey(.downArrow, modifierFlags: .command) // Move to the end
            for _ in 1...4 {
                $0.typeKey(.leftArrow, modifierFlags: []) // Move the text cursor left
            }
            $0.typeText("#") // Add a break instruction
        }
        
        // The program now looks like this: "++++++[>++++++<-]>......#...."
        // If we were to enable break instructions it would only print
        // 6 dollar signs "$$$$$$" before stopping
        
        // MARK: Test with Breaks Off
        
        // We have not yet enabled breaks, so it should run normally
        runButton.click()
        XCTAssertEqual("$$$$$$$$$$", output.value as? String) // Confirm that it works with breaks off...
        XCTAssertFalse(alertSheet.exists) // ...and that there is no error
        
        // MARK: Enable the Break Instruction
        
        menuBar.menuBarItems["Brainflip"].menuItems["Settings…"].click() // Open the settings window
        app.windows["com_apple_SwiftUI_Settings_window"].do {
            $0.toolbars.buttons["Interpreter"].click() // Switch to the Interpreter tab, if needed
            
            let breakInstructionToggle = $0.groups.containing(.staticText, identifier: "Stop on break instruction").switches.firstMatch
            breakInstructionToggle.click() // Enable break instructions
            $0.buttons[XCUIIdentifierCloseWindow].click() // Close the window
        }
        
        // MARK: Test with Breaks On
        
        // Now that breaks are on, it should stop after printing
        // 6 dollar signs "$$$$$$"
        runButton.click()
        XCTAssertEqual("$$$$$$", output.value as? String) // Confirm that it works with breaks on
        
        // BUT, we don't want to show any sort of error on a break
        XCTAssertFalse(alertSheet.exists)
    }
}
