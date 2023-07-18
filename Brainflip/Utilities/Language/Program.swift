import Foundation

/// Represents a Brainflip program.
typealias Program = Array<Instruction>

extension Program {
    /// Creates a program from a `String`.
    ///
    /// - Parameters:
    ///   - from: The `String` to convert.
    init(string program: String) {
        self = Self()
        for char in program {
            if let instruction = Instruction(rawValue: char), instruction != .blank {
                append(instruction)
            }
        }
        append(.blank)
    }
    
    /// Returns how many times the given instructions appear in this program.
    ///
    /// - Parameters:
    ///   - instructions: The instructions to look for when counting.
    ///
    /// - Returns: The amount of times the given instructions appear in this program.
    func instructionCount(_ instructions: Instruction...) -> Int {
        filter { instructions.contains($0) }.count
    }
    
    var description: String {
        String(map(\.rawValue))
    }
}
