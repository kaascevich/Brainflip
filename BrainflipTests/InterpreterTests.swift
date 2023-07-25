<<<<<<< HEAD
import XCTest
@testable import Brainflip

final class InterpreterTests: XCTestCase {
    let basicProgram = Program(string: ",[>+<-.]")
    let interpreter = Interpreter(program: basicProgram)
    
=======
//
//  InterpreterTests.swift
//  InterpreterTests
//
//  Created by Kaleb on 7/25/23.
//

import XCTest

final class InterpreterTests: XCTestCase {

>>>>>>> 53ae74fb843965c214cf27378bb4f9f0b22df097
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

<<<<<<< HEAD
    func testBasic() throws {
=======
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
>>>>>>> 53ae74fb843965c214cf27378bb4f9f0b22df097
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
