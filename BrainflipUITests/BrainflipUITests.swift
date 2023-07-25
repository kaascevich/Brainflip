import XCTest

final class BrainflipUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launchArguments += ["-ApplePersistenceIgnoreState", "YES"]
        app.launch()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: - Tests
    
    func testBasic() throws {
        let mainMenu = app.menuBars.firstMatch
        mainMenu.menuBarItems["File"].menuItems["New"].click()
        
        let documentWindow = app.windows["Untitled"]
        XCTAssert(documentWindow.waitForExistence(timeout: 2))
        
        let editor = documentWindow.textViews["Editor"]
        let input = documentWindow.textFields["Input"]
        let output = documentWindow.textViews["Output"]
        let runButton = documentWindow.buttons["Run Program"]
        let arrayField = documentWindow.textFields["Array"]
        let showArrayButton = documentWindow.buttons["Show Array"]
        let arrayPopoverCell1Value = app.descendants(matching: .any)["Cell 1 value"]

        editor.typeText(",[>+<-.]")
        input.click()
        input.typeText("b")
        
        runButton.click()
        
        let expectedOutput: String = (0x00...0x61).reduce("") { current, asciiCode in
            String(UnicodeScalar(asciiCode)!) + current
        }
        Thread.sleep(forTimeInterval: 0.2)
        XCTAssertEqual(expectedOutput, output.value as! String)
        XCTAssertEqual("[0, 98]", arrayField.value as! String)
        
        showArrayButton.click()
       // XCTAssert(showArrayButton.descendants(matching: .any).firstMatch.waitForExistence(timeout: 1))
        XCTAssertEqual("98", arrayPopoverCell1Value.value as! String)
    }
    
    /// Measures how long it takes to launch the app,
    func testLaunchPerformance() throws {
        let metrics = [
            XCTApplicationLaunchMetric(waitUntilResponsive: true)
        ]
        
        measure(metrics: metrics) {
            app.launch()
        }
    }
}
