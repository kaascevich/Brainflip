import Foundation
import SwiftUI

extension BrainflipToC {
    enum Whitespace: String, Codable, CaseIterable {
        // For the uninitiated: Surrounding a string with hashes (#) lets you use
        // plain quote marks within the string.
        case beforeWhileOrIf          = #"Before "(" in a "while" or "if" statement"#
        case beforeFunctionCall       = #"Before "(" in a function call or declaration"#
        case afterIfStatement         = #"After an "if" statement"#
        case beforePointerMark        = #"Before "*""#
        case afterPointerMark         = #"After "*""#
        case aroundAssignment         = #"Surrounding the "=" operator"#
        case aroundCompoundAssignment = #"Surrounding the "+=" operator"#
        case aroundNotEqual           = #"Surrounding the "!=" operator"#
        case aroundGreaterThanOrEqual = #"Surrounding the ">=" operator"#
        case aroundIncDec             = #"Surrounding "++" and "--""#
        case inParentheses            = #"Surrounding statements in parentheses"#
        case beforeCommas             = #"Before commas"#
        case afterCommas              = #"After commas"#
        case beforeBrace              = #"Before braces"#
        case beforeBrackets           = #"Before opening brackets"#
        case inBrackets               = #"Inside brackets"#
        case beforeSemicolon          = #"Before semicolons"#
        case afterSemicolon           = #"After semicolons"#
        case afterCommentMarkers      = #"After comment markers"#
        
        var enabled: Bool {
            get { settings.whitespace.contains(self) }
            nonmutating set {
                if newValue {
                    settings.whitespace.append(self)
                } else {
                    settings.whitespace.removeAll { $0 == self }
                }
            }
        }
        
        @Binding(
            get: {
                allCases.map(\.enabled)
            }, set: { newValues in
                zip(allCases, newValues).forEach { $0.enabled = $1 }
            }
        ) static var enabledWhitespace: [Bool]
    }
    
    static func whitespace(for type: Whitespace) -> String {
        type.enabled ? " " : ""
    }
}
