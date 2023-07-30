import Foundation

/// Represents a Brainflip program.
typealias Program = Array<Instruction>

extension Program {
    /// Creates a program from a `String`.
    ///
    /// - Parameters:
    ///   - from: The `String` to convert.
    init(string program: String) {
        self.init()
        program.compactMap(Instruction.init(rawValue:)).filter { $0 != .blank }.forEach { append($0) }
        append(.blank)
    }
    
    var description: String {
        String(map(\.rawValue))
    }
}
