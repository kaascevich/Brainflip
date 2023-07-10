import SwiftUI
import HighlightedTextEditor
import RegexBuilder

struct SyntaxHighlighting {
    static let highlightPatterns: [(String, Color)] = [
        // One(.anyOf("<>"))
        ("[<>]", .orange),
        // One(.anyOf("+-"))
        ("[+-]", .red),
        // One(.anyOf("[]"))
        (#"[\[\]]"#, .brown),
        // One(.anyOf(".,"))
        ("[.,]", .purple)
    ]
    
    static let highlightRules: [HighlightRule] = highlightPatterns.map {
        HighlightRule(
            pattern: try! NSRegularExpression(pattern: $0.0),
            formattingRule: TextFormattingRule(
                key: .foregroundColor,
                value: NSColor($0.1)
            )
        )
    }
}
