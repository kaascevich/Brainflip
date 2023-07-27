//import XCTest
//@testable import Interpreter
//
//final class InterpreterTests: XCTestCase {
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//    
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
//    
//    func testBasic() async throws {
//        let interpreter = Interpreter(program: "hello ,[>+<-.]", input: "b")
//        try await interpreter.run()
//        let expectedOutput: String = (0x00...0x61).reduce("") { current, asciiCode in
//            String(UnicodeScalar(asciiCode)!) + current
//        }
//        XCTAssertEqual(expectedOutput, interpreter.output)
//    }
//    
//    func testBreak() async throws {
//        let interpreter = Interpreter(program: ",[>+#<-.]", input: "b", breakOnHash: true)
//        await assertAsyncThrowsError(try await interpreter.run())
//    }
//    
//    func testEndOfInput() async throws {
//        let interpreter = Interpreter(program: ",[>+<-.]", onEndOfInput: .setToMax)
//        try await interpreter.run()
//        let expectedOutput: String = (0x00...0xFE).reduce("") { current, asciiCode in
//            String(UnicodeScalar(asciiCode)!) + current
//        }
//        XCTAssertEqual(expectedOutput, interpreter.output)
//    }
//    
//    func testBracketMatching() async throws {
//        let programs = [
//            ",[>+<-.",
//            ",[[>+<-.]",
//            ",>+<-.]",
//            ",>+<-.]]",
//        ]
//        
//        for program in programs {
//            let interpreter = Interpreter(program: program)
//            await assertAsyncThrowsError(try await interpreter.run())
//        }
//    }
//    
//    func testArrayBounds() async throws {
//        // MARK: Overflow + Array Sizes
//        let arraySizes = [30_000, 60_000, 30]
//        for arraySize in arraySizes {
//            let interpreter = Interpreter(program: "+[>+]", arraySize: arraySize)
//            await assertAsyncThrowsError(try await interpreter.run())
//            XCTAssertEqual(interpreter.cellArray.count, arraySize)
//            XCTAssert(interpreter.cellArray.allSatisfy { $0 == 1 })
//        }
//        
//        // MARK: Underflow
//        let interpreter = Interpreter(program: "<")
//        await assertAsyncThrowsError(try await interpreter.run())
//    }
//    
//    func testInterpreterPerformance() throws {
//        let numwarpProgram = ">>>>+>+++>+++>>>>>+++[>,+>++++[>++++<-]>[<<[-[->]]>[<]>-]<<[>+>+>>+>+[<<<<]<+>>[+<]<[>]>+[[>>>]>>+[<<<<]>-]+<+>>>-[<<+[>]>>+<<<+<+<--------[<<-<<+[>]>+<<-<<-[<<<+<-[>>]<-<-<<<-<----[<<<->>>>+<-[<<<+[>]>+<<+<-<-[<<+<-<+[>>]<+<<<<+<-[<<-[>]>>-<<<-<-<-[<<<+<-[>>]<+<<<+<+<-[<<<<+[>]<-<<-[<<+[>]>>-<<<<-<-[>>>>>+<-<<<+<-[>>+<<-[<<-<-[>]>+<<-<-<-[<<+<+[>]<+<+<-[>>-<-<-[<<-[>]<+<++++[<-------->-]++<[<<+[>]>>-<-<<<<-[<<-<<->>>>-[<<<<+[>]>+<<<<-[<<+<<-[>>]<+<<<<<-[>>>>-<<<-<-]]]]]]]]]]]]]]]]]]]]]]>[>[[[<<<<]>+>>[>>>>>]<-]<]>>>+>>>>>>>+>]<]<[-]<<<<<<<++<+++<+++[[>]>>>>>>++++++++[<<++++>++++++>-]<-<<[-[<+>>.<-]]<<<<[-[-[>+<-]>]>>>>>[.[>]]<<[<+>-]>>>[<<++[<+>--]>>-]<<[->+<[<++>-]]<<<[<+>-]<<<<]>>+>>>--[<+>---]<.>>[[-]<<]<]"
//        let numwarpInput = "0123456789"
//        
//        measureAsync(metrics: [XCTClockMetric(), XCTCPUMetric(), XCTMemoryMetric()]) {
//            let interpreter = Interpreter(program: numwarpProgram, input: numwarpInput)
//            try await interpreter.run()
//        }
//    }
//}
