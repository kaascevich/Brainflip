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

import Foundation

@resultBuilder
struct StringBuilder {
    static func buildBlock(_ components: String...) -> String { components.joined() }
    
    static func buildOptional(_ component: String?) -> String { component ?? "" }
    
    static func buildArray(_ components: [String]) -> String { components.joined() }
    
    static func buildEither(first  component: String) -> String { component }
    static func buildEither(second component: String) -> String { component }
    
    static func buildLimitedAvailability(_ component: String) -> String { component }
}

extension String {
    init(@StringBuilder _ stringBuilder: () -> String) {
        self = stringBuilder()
    }
}
