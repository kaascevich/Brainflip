import Cocoa
import Quartz
import SwiftUI

class PreviewProvider: QLPreviewProvider, QLPreviewingController {
    // We're using SwiftUI's Color type here instead of NSColor
    // to ensure pairity with the main app.
    typealias ColorHighlightRule = (Regex<Substring>, Color)
    static let highlightRules: [ColorHighlightRule] = [
        (/[<>]/,   .orange), // "<>"
        (/[+-]/,   .red),    // "+-"
        (/[\[\]]/, .brown),  // "[]"
        (/[.,]/,   .purple), // ".,"
        (/#/,      .green)   // "#"
    ]
    
    func providePreview(for request: QLFilePreviewRequest) async throws -> QLPreviewReply {
        let contentType = UTType.rtf
        
        let reply = QLPreviewReply.init(
            dataOfContentType: contentType,
            contentSize: CGSize.init(width: 800, height: 800)
        ) { replyToUpdate in
            let string = try! String(contentsOf: request.fileURL)
            let attributedString = NSMutableAttributedString(string: string)
            
            let colorGroups = PreviewProvider.highlightRules.map { regex, color in
                (color: color, ranges: string.ranges(of: regex))
            }
            for colorRanges in colorGroups {
                for range in colorRanges.ranges {
                    attributedString.addAttribute(
                        .foregroundColor,
                        value: NSColor(colorRanges.color),
                        range: NSRange(range, in: string)
                    )
                }
            }
            
            attributedString.addAttribute(
                .font,
                value: NSFont.monospacedSystemFont(ofSize: 14, weight: .regular),
                range: NSRange(0..<string.count)
            )
            
            let data = attributedString.rtf(from: NSRange(0..<attributedString.length))!
            return data
        }
                
        return reply
    }
}
