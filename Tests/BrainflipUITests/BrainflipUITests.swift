import XCTest

final class BrainflipUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launchArguments += ["-ApplePersistenceIgnoreState", "YES"]
        app.launchArguments += ["--ui-testing"]
        app.launch()
    }
    
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
        
        editor.click(); editor.typeText(simpleTestProgram)
        input.click(); input.typeText("b")

        runButton.click()
        
        let expectedOutput: String = (0x00...0x61).reduce("") { current, asciiCode in
            String(UnicodeScalar(asciiCode)!) + current
        }
        Thread.sleep(forTimeInterval: 0.5)
        XCTAssertEqual(expectedOutput, output.value as! String)
    }
    
    func testSamplePrograms() throws {
        let sampleProgramName = "Alphabet Printer"
        
        let menuBar = app.menuBars.firstMatch
        menuBar.menuItems["Sample Programs"].menuItems[sampleProgramName].click()
        
        let documentWindow = app.windows["\(sampleProgramName).bf"]
        XCTAssert(documentWindow.waitForExistence(timeout: 3))
        
        let output = documentWindow.scrollViews["Output"].textViews.firstMatch
        
        let expectedOutput: String = (0x00...0x61).reduce("") { current, asciiCode in
            String(UnicodeScalar(asciiCode)!) + current
        }
        Thread.sleep(forTimeInterval: 0.5)
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
        
        editor.click(); editor.typeText(simpleTestProgram)
        input.click(); input.typeText("b")
        
        runButton.click()
        
        showArrayButton.click()
        XCTAssertEqual("98", arrayPopoverCell1Value.value as! String)
        XCTAssertEqual("[0, 98]", arrayField.value as! String)
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
}
