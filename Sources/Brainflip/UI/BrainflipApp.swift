// BrainflipApp.swift
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

// @_exported effectively adds an implicit import statement to every file
// in the target. (It also does other things that don't matter if you're
// not creating an API.)
@_exported import Flow
@_exported import SymbolMacro

import SwiftUI

@main
struct BrainflipApp: App {
    var body: some Scene {
        MainDocumentScene()
        ASCIIChartScene()
        SettingsScene()
    }
    
    /// Sets up the app according to the launch arguments.
    init() {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--ui-testing") {
            settings.resetAllToDefaults()
        }
        #endif
    }
}
