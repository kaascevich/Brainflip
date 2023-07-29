import XCTest

final class BrainflipUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launchArguments += ["-ApplePersistenceIgnoreState", "YES"]
        app.launchArguments += ["--ui-testing"]
        app.launch()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Tests
    
    func testBasic() throws {
        app.typeKey("n", modifierFlags: .command)
        
        let documentWindow = app.windows["Untitled"]
        XCTAssert(documentWindow.waitForExistence(timeout: 3))
        
        let editor = documentWindow.textViews["Editor"]
        let input = documentWindow.textFields["Input"]
        let output = documentWindow.scrollViews["Output"].textViews.firstMatch
        let runButton = documentWindow.buttons["Run Program"]
        
        editor.click()
        editor.typeText(",[>+<-.]")
        input.click()
        input.typeText("b")

        runButton.click()
        
        let expectedOutput: String = (0x00...0x61).reduce("") { current, asciiCode in
            String(UnicodeScalar(asciiCode)!) + current
        }
        Thread.sleep(forTimeInterval: 0.5)
        XCTAssertEqual(expectedOutput, output.value as! String)
    }
    
    func testSamplePrograms() throws {
        let menuBar = app.menuBars.firstMatch
        menuBar.menuItems["Sample Programs"].menuItems["Alphabet Printer"].click()
        
        let documentWindow = app.windows["Alphabet Printer.bf"]
        XCTAssert(documentWindow.waitForExistence(timeout: 3))
        
        let input = documentWindow.textFields["Input"]
        let output = documentWindow.scrollViews["Output"].textViews.firstMatch
        let runButton = documentWindow.buttons["Run Program"]
        
        input.click()
        input.typeText("b")

        runButton.click()
        
        let expectedOutput: String = (0x00...0x61).reduce("") { current, asciiCode in
            String(UnicodeScalar(asciiCode)!) + current
        }
        Thread.sleep(forTimeInterval: 0.5)
        XCTAssertEqual(expectedOutput, output.value as! String)
    }
    
    func testShowArray() throws {
        try testSamplePrograms()
        
        let documentWindow = app.windows["Alphabet Printer.bf"]
        let arrayField = documentWindow.textFields["Array"]
        let showArrayButton = documentWindow.buttons["Show Array"]
        let arrayPopoverCell1Value = app.descendants(matching: .any)["Cell 1 value"]
        
        showArrayButton.click()
        XCTAssertEqual("98", arrayPopoverCell1Value.value as! String)
        XCTAssertEqual("[0, 98]", arrayField.value as! String)
    }
    
    /// Measures how long it takes to launch the app.
    func testLaunchPerformance() throws {
        let metrics = [
            XCTApplicationLaunchMetric(waitUntilResponsive: true)
        ]
        
        measure(metrics: metrics) {
            app.launch()
        }
    }
}
