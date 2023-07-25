import XCTest
@testable import Brainflip

final class InterpreterTests: XCTestCase {
    let basicProgram = Program(string: ",[>+<-.]")
    let interpreter = Interpreter(program: basicProgram)
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBasic() throws {
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
