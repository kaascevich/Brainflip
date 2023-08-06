// BrainflipPerformanceTests.swift
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
