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

// swiftlint:disable type_body_length function_body_length

import Flow
import XCTest

final class BrainflipUITests: XCTestCase {
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
        let expectedOutput = String(
            (0...inputASCIICode - 1)
                .map { String(Unicode.Scalar($0)) }
                .reduce("", +)
                .reversed()
        )
        
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
        try menuBar.menuBarItems["View"].menuItems.do {
            try assertExistsAndClick($0[hideOutput], after: 1.5)
            try assertExistsAndClick($0[showOutput], after: 1.5)
            
            try assertExistsAndClick($0[hideInspector], after: 1.5)
            try assertExistsAndClick($0[showInspector], after: 1.5)
        }
        
        // MARK: Toolbar
        try documentWindow.toolbars.checkBoxes.do {
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
            $0.typeText("++[>+<-]")
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
        
        let program = "++++++[>++++++<-]>..." // prints 3 dollar signs $$$
        let inputText = "testing, testing"
        
        // MARK: Clearing All
        
        editor.do {
            $0.click()
            $0.typeText(program)
        }
        input.do {
            $0.click()
            $0.typeText(inputText)
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
            $0.typeText(inputText)
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
        
        editor.click(); editor.typeText(program)
        
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
            menuBar.menuItems["paste:"].click() // Paste the clipboard contents
            Thread.sleep(forTimeInterval: 1) // Give the paste command some time to work
            XCTAssertEqual(program + result, $0.value as? String)
        }
        
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
            Thread.sleep(forTimeInterval: 1) // Give the paste command some time to work
            XCTAssertEqual(program + result + testingText, $0.value as? String)
        }
    }
    
    func testProgramSizeAndTrim() throws {
        // MARK: Setup
        
        let menuBar = app.menuBars.firstMatch
        app.typeKey("n", modifierFlags: .command) // Creates a new document
        
        let documentWindow = app.windows["Untitled"]
        XCTAssert(documentWindow.waitForExistence(timeout: 3))
        
        let editor = documentWindow.textViews["Editor"]
        let programSize = documentWindow.staticTexts["Program Size"]
        let alertSheet = documentWindow.sheets["alert"]
        let okButton = alertSheet.buttons["action-button-1"]
        
        // MARK: Program Size Check
        
        editor.do {
            $0.click()
            $0.typeText("""
            [This program outputs "Hello World!" and a newline. Its length is 106 active instructions. (It is not the shortest.)]
            
            [These loops are "initial comment loops", a simple way of adding comments to a Brainflip program such that you don't have to worry about any instructions. Any ".", ",", "+", "-", "<" and ">" characters are simply ignored, the "[" and "]" characters just have to be balanced. This loop and the instructions it contains are ignored because the current cell defaults to a value of 0; the 0 value causes this loop to be skipped.]
            
            ++++++++       Set cell 0 to 8
            [
             >++++         Add 4 to cell 1; this always sets it to 4
             [             as the cell will be cleared by the loop
              >++          Add 2 to cell 2
              >+++         Add 3 to cell 3
              >+++         Add 3 to cell 4
              >+           Add 1 to cell 5
              <<<<-        Decrement the loop counter in cell 1
             ]             Loop until cell 1 is zero; 4 iterations
             >+            Add 1 to cell 2
             >+            Add 1 to cell 3
             >-            Subtract 1 from cell 4
             >>+           Add 1 to cell 6
             [<]           Move back to the first zero cell found; this will
                           be cell 1 which was cleared by the previous loop
             <-            Decrement the loop counter in cell 0
            ]              Loop until cell 0 is zero; 8 iterations
            
            The result of this is:
            Cell no :   0   1   2   3   4   5   6
            Contents:   0   0  72 104  88  32   8
            Pointer :   ^
            
            >>.            Cell 2 has value 72 which is 'H'
            >---.          Subtract 3 from cell 3 to get 101 which is 'e'
            +++++++..+++.  Likewise for 'llo' from cell 3
            >>.            Cell 5 is 32 for the space
            <-.            Subtract 1 from cell 4 for 87 to get a 'W'
            <.             Cell 3 was set to 'o' from the end of 'Hello'
            +++.------.    Cell 3 for 'rl'
            --------.      Cell 3 for 'd' too
            >>+.           Add 1 to cell 5 to get an exclamation point
            >++.           And finally a newline from cell 6
            """)
        }
        
        XCTAssertEqual("1,893 bytes, 130 bytes executable", programSize.value as? String)
        
        // MARK: Trimming
        
        menuBar.menuItems["Trim"].click()
        alertSheet.do {
            XCTAssert($0.waitForExistence(timeout: 0.5))
            okButton.click()
        }
        
        Thread.sleep(forTimeInterval: 0.5) // give the trim command some leeway
        XCTAssertEqual("130 bytes, 130 bytes executable", programSize.value as? String)
    }
}

// swiftlint:enable type_body_length function_body_length
