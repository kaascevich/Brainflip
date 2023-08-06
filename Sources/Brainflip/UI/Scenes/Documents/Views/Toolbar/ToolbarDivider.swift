// ToolbarDivider.swift
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

import SwiftUI

// The built-in Divider view doesn't look very good in toolbars.
// So I'm creating my own.
struct ToolbarDivider: ToolbarContent {
    var body: some ToolbarContent {
        ToolbarItem {
            Rectangle()
                .frame(width: 1, height: 20)
                .foregroundStyle(.quaternary)
                .padding(.horizontal, 5)
        }
    }
}
