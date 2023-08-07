// PreviewProvider.swift
// Copyright © 2023 Kaleb A. Ascevich
//
// This app is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This app is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
// for more details.
//
// You should have received a copy of the GNU General Public License along
// with this app. If not, see https://www.gnu.org/licenses/.

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
        ) { _ in
            guard let string = try? String(contentsOf: request.fileURL) else {
                return Data()
            }
            let attributedString = NSMutableAttributedString(string: string)
            
            let colorGroups = Self.highlightRules.map { regex, color in
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
