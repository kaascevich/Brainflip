import SwiftUI
import HighlightedTextEditor

struct SyntaxHighlighting {    
    static var hashColor: Color = settings.breakOnHash ? .green : .gray
    static var highlightPatterns: [(String, Color)] = [
        ("[<>]",     .orange),   // "<>"
        ("[+-]",     .red),      // "+-"
        (#"[\[\]]"#, .brown),    // "[]"
        ("[\\.,]",   .purple),   // ".,"
        ("#",         hashColor) // "#"
    ]
    
    static var highlightRules: [HighlightRule] = highlightPatterns.map { (regex, color) in
        HighlightRule(
            pattern: try! NSRegularExpression(pattern: regex),
            formattingRule: TextFormattingRule(
                key: .foregroundColor,
                value: NSColor(color)
            )
        )
    }
}
