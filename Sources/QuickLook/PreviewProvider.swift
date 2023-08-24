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

import Quartz
import SwiftUI

class PreviewProvider: QLPreviewProvider, QLPreviewingController {
    // We're using SwiftUI's Color type here instead of NSColor
    // to ensure parity with the main app.
    typealias ColorHighlightRule = (Regex<Substring>, Color)
    static let highlightRules: [ColorHighlightRule] = [
        (/[<>]/,   .orange), // "<>"
        (/[+-]/,   .red),    // "+-"
        (/[\[\]]/, .brown),  // "[]"
        (/[.,]/,   .purple), // ".,"
        (/#/,      .green)   // "#"
    ]
    
    func providePreview(for request: QLFilePreviewRequest) async throws -> QLPreviewReply {
        QLPreviewReply(
            dataOfContentType: .rtf,
            contentSize: CGSize(width: 800, height: 800)
        ) { _ in
            guard let string = try? String(contentsOf: request.fileURL) else {
                return Data()
            }
            let attributedString = NSMutableAttributedString(string: string)
            
            Self.highlightRules.map { regex, color in
                (ranges: string.ranges(of: regex), color: color)
            }
            .forEach { (ranges, color) in
                ranges.forEach { range in
                    attributedString.addAttribute(
                        .foregroundColor,
                        value: NSColor(color),
                        range: NSRange(range, in: string)
                    )
                }
            }
            
            attributedString.addAttribute(
                .font,
                value: NSFont.monospacedSystemFont(ofSize: 14, weight: .regular),
                range: NSRange(0..<string.count)
            )
            
            let all = NSRange(0..<attributedString.length)
            return attributedString.rtf(from: all)!
        }
    }
}
