import Foundation

extension BrainflipToC {
    static func surround(_ string: String, with space: Whitespace) -> String {
        surround(string, before: space, after: space)
    }
    
    static func surround(_ string: String, before beforeSpace: Whitespace, after afterSpace: Whitespace) -> String {
        String {
            whitespace(for: beforeSpace)
            string
            whitespace(for: afterSpace)
        }
    }
    
    static func pointerMark(whitespaceBefore: Bool = true, whitespaceAfter: Bool = true) -> String {
        String {
            if whitespaceBefore {
                whitespace(for: .beforePointerMark)
            } else { "" }
            
            Symbols.pointer
            
            if whitespaceAfter {
                whitespace(for: .afterPointerMark)
            } else { "" }
        }
    }
}
