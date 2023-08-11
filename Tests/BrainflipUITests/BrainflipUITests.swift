// BrainflipUITests.swift
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

final class BrainflipUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launchArguments += ["-ApplePersistenceIgnoreState", "YES"]
        app.launchArguments += ["--ui-testing"]
        app.launch()
    }
    
    /// Outputs every ASCII character below the input.
    let simpleTestProgram = ",[>+<-.]"
    
    // MARK: - Tests
    
    func testSamplePrograms() throws {
        // MARK: Setup
        
        let sampleProgramName = "Alphabet Printer"
        let sampleProgramContents = """
        Prints all ASCII characters before the input character in the ASCII table
        Uses one of each Brainflip instruction
        ,[>+<-.]
        """
        
        let menuBar = app.menuBars.firstMatch
        menuBar.menuItems["Sample Programs"].menuItems[sampleProgramName].click() // Open the Alphabet Printer sample program
        
        let documentWindow = app.windows["\(sampleProgramName).bf"]
        XCTAssert(documentWindow.waitForExistence(timeout: 3))
        
        let editor = documentWindow.textViews["Editor"]
        let input = documentWindow.textFields["Input"]
        let output = documentWindow.scrollViews["Output"].textViews.firstMatch
        let runButton = documentWindow.buttons["run-button-main"]
        
        let inputText = "b"
        let inputASCIICode = Character(inputText).asciiValue!
        
        // MARK: Running
        XCTAssertEqual(sampleProgramContents, editor.value as? String)
        
        input.do {
            $0.click()
            $0.typeText(inputText)
        }
        runButton.click()
        
        // Swift won't let us store invisible ASCII characters in strings.
        // So we need to put it together manually.
        let expectedOutput = (0...inputASCIICode - 1)
            .map { String(Unicode.Scalar($0)) }
            .reduce("", +)
            .reversed()
            .let(String.init(_:))
        
        Thread.sleep(forTimeInterval: 1) // Let the interpreter do its thing
        XCTAssertEqual(expectedOutput, output.value as? String)
    }
    
    func testShowArray() throws {
        // MARK: Setup
        
        app.typeKey("n", modifierFlags: .command) // Creates a new document
        
        let documentWindow = app.windows["Untitled"]
        XCTAssert(documentWindow.waitForExistence(timeout: 3))
                
        let editor = documentWindow.textViews["Editor"]
        let input = documentWindow.textFields["Input"]
        let arrayField = documentWindow.textFields["Array"]
        let showArrayButton = documentWindow.buttons["Show Array"]
        let arrayPopoverCell1Value = app.descendants(matching: .any)["Cell 1"]
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
        Thread.sleep(forTimeInterval: 1) // Let the interpreter do its thing
        
        // MARK: Showing the Array
        
        showArrayButton.click()
        XCTAssertEqual("\(inputASCIICode)", arrayPopoverCell1Value.value as? String)
        XCTAssertEqual("[0, \(inputASCIICode)]", arrayField.value as? String)
    }
    
    func testPaneHiding() throws {
        // MARK: Setup
        
        let menuBar = app.menuBars.firstMatch
        menuBar.menuItems["newDocument:"].click() // Creates a new document
        
        let documentWindow = app.windows["Untitled"]
        XCTAssert(documentWindow.waitForExistence(timeout: 3))
        
        let hideOutput = "Hide Output"
        let showOutput = "Show Output"
        let hideInspector = "Hide Inspector"
        let showInspector = "Show Inspector"
        
        func assertExistsAndClick(_ element: XCUIElement, after timeout: TimeInterval) throws {
            XCTAssert(element.waitForExistence(timeout: timeout))
            element.click()
        }
        
        // MARK: View Menu
        let viewMenu = menuBar.menuBarItems["View"]
        viewMenu.menuItems.do {
            try assertExistsAndClick($0[hideOutput], after: 1.5)
            try assertExistsAndClick($0[showOutput], after: 1.5)
            
            try assertExistsAndClick($0[hideInspector], after: 1.5)
            try assertExistsAndClick($0[showInspector], after: 1.5)
        }
        
        // MARK: Toolbar
        let toolbar = documentWindow.toolbars
        toolbar.checkBoxes.do {
            try assertExistsAndClick($0[hideOutput], after: 1.5)
            try assertExistsAndClick($0[showOutput], after: 1.5)
            
            try assertExistsAndClick($0[hideInspector], after: 1.5)
            try assertExistsAndClick($0[showInspector], after: 1.5)
        }
    }
    
    func testStepThrough() throws {
        // MARK: Setup
        
        app.typeKey("n", modifierFlags: .command) // Creates a new document
        
        let documentWindow = app.windows["Untitled"]
        XCTAssert(documentWindow.waitForExistence(timeout: 3))
        
        let editor = documentWindow.textViews["Editor"]
        let stepButton = documentWindow.buttons["step-button-main"]
        
        editor.do {
            $0.click()
            $0.typeText(("++[>+<-]"))
        }
        
        // MARK: Stepping Through
        
        for _ in 1...13 {
            XCTAssert(stepButton.isEnabled)
            stepButton.click()
        }
        XCTAssertFalse(stepButton.isEnabled)
    }
    
    func testClear() throws {
        // MARK: Setup
        
        app.typeKey("n", modifierFlags: .command) // Creates a new document
        
        let documentWindow = app.windows["Untitled"]
        XCTAssert(documentWindow.waitForExistence(timeout: 3))
        
        let editor = documentWindow.textViews["Editor"]
        let input = documentWindow.textFields["Input"]
        let output = documentWindow.scrollViews["Output"].textViews.firstMatch
        let runButton = documentWindow.buttons["run-button-main"]
        
        let alertSheet = documentWindow.sheets["alert"]
        let clearButton = alertSheet.buttons["action-button-1"]
        
        let program = "++++++[>++++++<-]>..."
        let input = "testing, testing"
        
        // MARK: Clearing All
        
        editor.do {
            $0.click()
            $0.typeText(program)
        }
        input.do {
            $0.click()
            $0.typeText(input)
        }
        runButton.click()
        XCTAssertEqual("$$$", output.value as? String)
        
        documentWindow.do {
            $0.popUpButtons["Clear"].click()
            $0.menuItems["Clear All…"].click()
        }
        
        XCTAssert(alertSheet.waitForExistence(timeout: 0.5))
        clearButton.click()
        
        Thread.sleep(forTimeInterval: 0.5) // Give the clear command some time to work
        XCTAssertEqual("", editor.value as? String)
        XCTAssertEqual("", input.value as? String)
        XCTAssertEqual("", output.value as? String)
        
        // MARK: Clearing Input
        
        editor.do {
            $0.click()
            $0.typeText(program)
        }
        input.do {
            $0.click()
            $0.typeText(input)
        }
        runButton.click()
        XCTAssertEqual("$$$", output.value as? String)
        
        documentWindow.do {
            $0.popUpButtons["Clear"].click()
            $0.menuItems["Clear Input"].click()
        }
        
        Thread.sleep(forTimeInterval: 0.5) // Give the clear command some time to work
        XCTAssertEqual("", input.value as? String)
        XCTAssertNotEqual("", editor.value as? String)
        XCTAssertNotEqual("", output.value as? String)
    }
    
    func testCopyPasteButtons() throws {
        // MARK: Setup
        
        let menuBar = app.menuBars.firstMatch
        app.typeKey("n", modifierFlags: .command) // Creates a new document
        
        let documentWindow = app.windows["Untitled"]
        XCTAssert(documentWindow.waitForExistence(timeout: 3))
        
        let editor = documentWindow.textViews["Editor"]
        let input = documentWindow.textFields["Input"]
        let output = documentWindow.scrollViews["Output"].textViews.firstMatch
        let runButton = documentWindow.buttons["run-button-main"]
        
        let copyOutputButton = documentWindow.buttons["Copy Output"]
        let copyInputButton = documentWindow.buttons["Copy Input"]
        let pasteButton = documentWindow.buttons["Paste"]
        
        // Outputs "Hello World!"
        let program = "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>-[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+."
        let result = "Hello World!"
        
        editor.do {
            $0.click()
            $0.typeText(program)
        }
        
        runButton.click()
        Thread.sleep(forTimeInterval: 1) // Let the interpreter do its thing
        XCTAssertEqual(result, output.value as? String)
        
        // MARK: Copying and Pasting
        
        copyOutputButton.click()
        
        pasteButton.click()
        XCTAssertEqual(result, input.value as? String)
        
        // Confirm that the text was actually put on the clipboard
        // (can't hurt to be sure, am I right?)
        editor.do {
            $0.click()
            $0.typeKey(.downArrow, modifierFlags: .command) // Moves to the end of the document
        }
        menuBar.menuItems["paste:"].click() // Paste the clipboard contents
        Thread.sleep(forTimeInterval: 1) // Give the paste command some time to work
        XCTAssertEqual(program + result, editor.value as? String)
        
        // Test the input's copy button
        
        let testingText = "Testing, testing"
        
        input.do {
            $0.click()
            $0.typeKey("a", modifierFlags: .command) // Select all
            $0.typeText(testingText)
        }
        
        copyInputButton.click()
        
        editor.do {
            $0.click()
            $0.typeKey(.downArrow, modifierFlags: .command) // Moves to the end of the document
            $0.typeKey("v", modifierFlags: .command) // Paste the clipboard contents
        }
        Thread.sleep(forTimeInterval: 1) // Give the paste command some time to work
        XCTAssertEqual(program + result + testingText, editor.value as? String)
    }
}
