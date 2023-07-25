<<<<<<< HEAD
import XCTest

final class BrainflipUITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launchArguments += ["-ApplePersistenceIgnoreState", "YES"]
        app.launch()
=======
//
//  BrainflipUITests.swift
//  BrainflipUITests
//
//  Created by Kaleb on 7/25/23.
//

import XCTest

final class BrainflipUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
>>>>>>> 53ae74fb843965c214cf27378bb4f9f0b22df097
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
<<<<<<< HEAD
    
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

=======

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
>>>>>>> 53ae74fb843965c214cf27378bb4f9f0b22df097
