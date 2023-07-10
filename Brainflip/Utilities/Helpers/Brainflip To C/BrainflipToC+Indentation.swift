import Foundation

extension BrainflipToC {
    static var indentLevel = 0
    static var indent: String {
        String(repeating: baseIndent, count: indentLevel)
    }
    
    static var baseIndent: String {
        String(repeating: Symbols.space, count: settings.indentation)
    }
}
