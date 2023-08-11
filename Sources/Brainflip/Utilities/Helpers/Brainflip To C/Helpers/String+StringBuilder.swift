// String+StringBuilder.swift
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

@resultBuilder
enum StringBuilder {
    static func buildBlock(_ strings: String...) -> String {
        strings.joined()
    }
    
    static func buildOptional(_ string: String?) -> String {
        string ?? ""
    }
    
    static func buildEither(first string: String) -> String {
        string
    }
    static func buildEither(second string: String) -> String {
        string
    }
}

extension String {
    init(@StringBuilder stringBuilder: () -> String) {
        self = stringBuilder()
    }
}
