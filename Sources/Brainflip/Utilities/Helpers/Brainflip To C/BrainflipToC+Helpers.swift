// BrainflipToC+Helpers.swift
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

extension BrainflipToC {
    @StringBuilder
    static func surround(_ string: String, with space: Whitespace) -> String {
        whitespace(for: space)
        string
        whitespace(for: space)
    }
    
    @StringBuilder
    static func pointerMark(whitespaceBefore: Bool = true, whitespaceAfter: Bool = true) -> String {
        if whitespaceBefore {
            whitespace(for: .beforePointerMark)
        }
        
        "*"
        
        if whitespaceAfter {
            whitespace(for: .afterPointerMark)
        }
    }
}
