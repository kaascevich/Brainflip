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
    
    func testBasic() throws {
        app.typeKey("n", modifierFlags: .command)
        
        let documentWindow = app.windows["Untitled"]
        XCTAssert(documentWindow.waitForExistence(timeout: 3))
        
        let editor = documentWindow.textViews["Editor"]
        let input = documentWindow.textFields["Input"]
        let output = documentWindow.scrollViews["Output"].textViews.firstMatch
        let runButton = documentWindow.buttons["run-button-main"]
        
        let inputText = "b"
        let inputASCIICode = Character(inputText).asciiValue!
        
        editor.click(); editor.typeText(simpleTestProgram)
        input.click(); input.typeText(inputText)

        runButton.click()
        
        // Swift won't let us store invisible ASCII characters in strings.
        // So we need to put it together manually.
        let expectedOutput: String = (0...inputASCIICode - 1).map { asciiCode in
            String(UnicodeScalar(asciiCode))
        }.reduce("", +)
        
        Thread.sleep(forTimeInterval: 0.5)
        XCTAssertEqual(expectedOutput, output.value as! String)
    }
    
    func testSamplePrograms() throws {
        let sampleProgramName = "Alphabet Printer"
        
        let menuBar = app.menuBars.firstMatch
        menuBar.menuItems["Sample Programs"].menuItems[sampleProgramName].click()
        
        let documentWindow = app.windows["\(sampleProgramName).bf"]
        XCTAssert(documentWindow.waitForExistence(timeout: 3))
        
        let input = documentWindow.textFields["Input"]
        let output = documentWindow.scrollViews["Output"].textViews.firstMatch
        let runButton = documentWindow.buttons["run-button-main"]
        
        let inputText = "b"
        let inputASCIICode = Character(inputText).asciiValue!
        
        input.click(); input.typeText(inputText)
        runButton.click()
        
        // Swift won't let us store invisible ASCII characters in strings.
        // So we need to put it together manually.
        let expectedOutput: String = (0...inputASCIICode - 1).map { asciiCode in
            String(UnicodeScalar(asciiCode))
        }.reduce("", +)
        
        Thread.sleep(forTimeInterval: 1) // Let the interpreter do its thing
        XCTAssertEqual(expectedOutput, output.value as! String)
    }
    
    func testShowArray() throws {
        app.typeKey("n", modifierFlags: .command)
        
        let documentWindow = app.windows["Untitled"]
        XCTAssert(documentWindow.waitForExistence(timeout: 3))
                
        let editor = documentWindow.textViews["Editor"]
        let input = documentWindow.textFields["Input"]
        let arrayField = documentWindow.textFields["Array"]
        let showArrayButton = documentWindow.buttons["Show Array"]
        let arrayPopoverCell1Value = app.descendants(matching: .any)["Cell 1 value"]
        let runButton = documentWindow.buttons["run-button-main"]
        
        let inputText = "b"
        let inputASCIICode = Character(inputText).asciiValue!
        
        editor.click(); editor.typeText(simpleTestProgram)
        input.click(); input.typeText(inputText)
        
        runButton.click()
        Thread.sleep(forTimeInterval: 1) // Let the interpreter do its thing
        
        showArrayButton.click()
        XCTAssertEqual("\(inputASCIICode)", arrayPopoverCell1Value.value as! String)
        XCTAssertEqual("[0, \(inputASCIICode)]", arrayField.value as! String)
    }
    
    func testPaneHiding() throws {
        let menuBar = app.menuBars.firstMatch
        menuBar.menuItems["newDocument:"].click()
        
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
        try assertExistsAndClick(viewMenu.menuItems[hideOutput], after: 1.5)
        try assertExistsAndClick(viewMenu.menuItems[showOutput], after: 1.5)
        
        try assertExistsAndClick(viewMenu.menuItems[hideInspector], after: 1.5)
        try assertExistsAndClick(viewMenu.menuItems[showInspector], after: 1.5)
        
        // MARK: Toolbar
        let toolbar = documentWindow.toolbars
        try assertExistsAndClick(toolbar.checkBoxes[hideOutput], after: 1.5)
        try assertExistsAndClick(toolbar.checkBoxes[showOutput], after: 1.5)
        
        try assertExistsAndClick(toolbar.checkBoxes[hideInspector], after: 1.5)
        try assertExistsAndClick(toolbar.checkBoxes[showInspector], after: 1.5)
    }
    
    func testStepThrough() throws {
        app.typeKey("n", modifierFlags: .command)
        
        let documentWindow = app.windows["Untitled"]
        XCTAssert(documentWindow.waitForExistence(timeout: 3))
        
        let editor = documentWindow.textViews["Editor"]
        let stepButton = documentWindow.buttons["step-button-main"]
                
        editor.click(); editor.typeText("++[>+<-]")

        for _ in 1...13 {
            XCTAssert(stepButton.isEnabled)
            stepButton.click()
        }
        XCTAssertFalse(stepButton.isEnabled)
    }
    
    func testCopyPasteButtons() throws {
        let menuBar = app.menuBars.firstMatch
        app.typeKey("n", modifierFlags: .command)
        
        let documentWindow = app.windows["Untitled"]
        XCTAssert(documentWindow.waitForExistence(timeout: 3))
        
        let editor = documentWindow.textViews["Editor"]
        let input = documentWindow.textFields["Input"]
        let output = documentWindow.scrollViews["Output"].textViews.firstMatch
        let runButton = documentWindow.buttons["run-button-main"]
        
        let copyButton = documentWindow.buttons["Copy"]
        let pasteButton = documentWindow.buttons["Paste"]
        
        // Outputs "Hello World!"
        let program = "++++++++[>++++[>++>+++>+++>+<<<<-]>+>+>-[<]<-]>>.>---.+++++++..+++.>>.<-.<.+++.------.--------.>>+."
        let result = "Hello World!"
        
        editor.click(); editor.typeText(program)
        
        runButton.click()
        Thread.sleep(forTimeInterval: 1) // Let the interpreter do its thing
        XCTAssertEqual(result, output.value as! String)
        
        copyButton.click()
        
        pasteButton.click()
        XCTAssertEqual(result, input.value as! String)
        
        // Confirm that the text was actually put on the clipboard
        // (can't hurt to be sure, am I right?)
        editor.click()
        editor.typeKey(.downArrow, modifierFlags: .command) // Moves to the end of the document
        menuBar.menuItems["paste:"].click() // Paste the clipboard contents
        Thread.sleep(forTimeInterval: 1) // Give the paste command some time to work
        XCTAssertEqual(program + result, editor.value as! String)
    }
}
