// MainDocumentScene.swift
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

struct MainDocumentScene: Scene {
    var body: some Scene {
        DocumentGroup {
            BrainflipDocument()
        } editor: { file in
            let state = AppState(document: file.document, isLocked: !file.isEditable)
            
            MainDocumentView(state: state)
                .environmentObject(settings)
                .environment(state)
                .focusedSceneValue(\.appState, state)
                .toolbar {
                    ToolbarContentView()
                }
            
            MenuCommandAlerts(state: state)
                .environmentObject(settings)
        }
        .defaultSize(width: 735, height: 460)
        .commands {
            MenuBarCommands()
            ToolbarCommands()
            TextEditingCommands()
        }
        .windowToolbarStyle(.unifiedCompact)
    }
}

extension FocusedValues {
    struct AppStateFocusedValues: FocusedValueKey {
        typealias Value = AppState
    }
    
    var appState: AppState? {
        get {
            self[AppStateFocusedValues.self]
        }
        set {
            self[AppStateFocusedValues.self] = newValue
        }
    }
}
