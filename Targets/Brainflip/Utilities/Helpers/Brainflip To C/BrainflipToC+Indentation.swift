import Foundation

extension BrainflipToC {
    /// The current indent level.
    ///
    /// `0` means that there is no indent, i.e. we're on the
    /// top level.
    static var indentLevel = 0
    
    static var indent: String {
        String(repeating: baseIndent, count: indentLevel)
    }
    
    /// The indentation used when ``indentLevel`` equals 1.
    static var baseIndent: String {
        String(repeating: Symbols.space, count: settings.indentation)
    }
}
