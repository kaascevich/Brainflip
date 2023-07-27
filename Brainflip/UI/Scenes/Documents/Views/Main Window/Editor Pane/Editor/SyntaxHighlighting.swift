import SwiftUI
import HighlightedTextEditor
import RegexBuilder

struct SyntaxHighlighting {
    static var highlightPatterns: [(String, Color)] {[
        // One(.anyOf("<>"))
        ("[<>]", .orange),
        // One(.anyOf("+-"))
        ("[+-]", .red),
        // One(.anyOf("[]"))
        (#"[\[\]]"#, .brown),
        // One(.anyOf(".,"))
        ("[\\.,]", .purple),
        // One("#")
        ("#", settings.breakOnHash ? .green : .gray),
    ]}
    
    static var highlightRules: [HighlightRule] {
        highlightPatterns.map {
            HighlightRule(
                pattern: try! NSRegularExpression(pattern: $0.0),
                formattingRule: TextFormattingRule(
                    key: .foregroundColor,
                    value: NSColor($0.1)
                )
            )
        }
    }
}
