import XCTest

final class BrainflipPerformanceTests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launchArguments += ["-ApplePersistenceIgnoreState", "YES"]
        app.launchArguments += ["--ui-testing"]
        app.launch()
    }
    
    // MARK: - Tests
    
    /// Measures how long it takes to launch the app.
    func testLaunchPerformance() throws {
        let metrics: [XCTMetric] = [
            XCTApplicationLaunchMetric(waitUntilResponsive: true)
        ]
        
        measure(metrics: metrics) {
            app.launch()
        }
    }
    
    /// Measures how long it takes to open a document.
    func testOpenPerformance() throws {
        let metrics: [XCTMetric] = [
            XCTClockMetric(),
            XCTCPUMetric(),
            XCTMemoryMetric()
        ]
        let options = XCTMeasureOptions()
        options.invocationOptions = .manuallyStart
        
        let programName = "Numwarp"
        let menuBar = app.menuBars.firstMatch
        let openSampleProgram = menuBar.menuItems["Sample Programs"].menuItems[programName]
        let documentWindow = app.windows["\(programName).bf"]
        
        measure(metrics: metrics, options: options) {
            app.launch()
            
            openSampleProgram.click()
            
            startMeasuring()
            _ = documentWindow.waitForExistence(timeout: .infinity)
        }
    }
}
