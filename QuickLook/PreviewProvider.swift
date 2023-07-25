import Cocoa
import Quartz
import SwiftUI

class PreviewProvider: QLPreviewProvider, QLPreviewingController {
    static let highlightPatterns: [(Regex, Color)] = [
        // One(.anyOf("<>"))
        (/[<>]/, .orange),
        // One(.anyOf("+-"))
        (/[+-]/, .red),
        // One(.anyOf("[]"))
        (/[\[\]]/, .brown),
        // One(.anyOf(".,"))
        (/[.,]/, .purple),
        // One("#")
        (/#/, .green)
    ]
    
    func providePreview(for request: QLFilePreviewRequest) async throws -> QLPreviewReply {
        let contentType = UTType.rtf
        
        let reply = QLPreviewReply.init(
            dataOfContentType: contentType,
            contentSize: CGSize.init(width: 800, height: 800)
        ) { replyToUpdate in
            let string = try! String(contentsOf: request.fileURL)
            let attributedString = NSMutableAttributedString(string: string)
            
            let colorGroups = PreviewProvider.highlightPatterns.map { range, color in
                (color: color, ranges: string.ranges(of: range))
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
                range: NSMakeRange(0, string.count)
            )
            
            let data = attributedString.rtf(from: NSMakeRange(0, attributedString.length))!
            return data
        }
                
        return reply
    }
}
