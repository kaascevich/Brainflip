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
        
        let documentWindow = app.windows.firstMatch
        XCTAssert(documentWindow.waitForExistence(timeout: 2))
        
        let editor = documentWindow.textViews["Editor"]
        let input = documentWindow.textFields["Input"]
        let output = documentWindow.textViews["Output"]
        let runButton = documentWindow.buttons["Run Program"]
        
        editor.typeText(",[>+<-.]")
        input.click()
        input.typeText("b")
        
        runButton.click()
        
        let expectedOutput: String = (0x00...0x61).reduce("") { current, asciiCode in
            String(UnicodeScalar(asciiCode)!) + current
        }
        Thread.sleep(forTimeInterval: 0.2)
        XCTAssertEqual(output.value as! String, expectedOutput)
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

