import SwiftUI
import HighlightedTextEditor

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
        highlightPatterns.map { (regex, color) in
            HighlightRule(
                pattern: try! NSRegularExpression(pattern: regex),
                formattingRule: TextFormattingRule(
                    key: .foregroundColor,
                    value: NSColor(color)
                )
            )
        }
    }
}
