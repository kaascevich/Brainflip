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
        program.compactMap(Instruction.init).filter { $0 != .blank }.forEach { append($0) }
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
