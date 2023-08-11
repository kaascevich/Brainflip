// BrainflipToC+Indentation.swift
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
    /// The current indent level.
    ///
    /// `0` means that there is no indent, i.e. we're on the
    /// top level.
    static var indentLevel = 0
    
    static var indent: String {
        .init(repeating: baseIndent, count: indentLevel)
    }
    
    /// The indentation used when ``indentLevel`` equals 1.
    static var baseIndent: String {
        .init(repeating: " ", count: settings.indentation)
    }
}
