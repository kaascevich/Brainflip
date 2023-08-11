// SettingsView.swift
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

struct SettingsView: View {
    struct Tab {
        var name: String
        var symbol: String
        var view: any View
    }
    
    static let tabs = [
        Tab(
            name: "General",
            symbol: "gearshape",
            view: GeneralSettings()
        ), Tab(
            name: "Sound",
            symbol: "volume.3",
            view: SoundSettings()
        ), Tab(
            name: "Interpreter",
            symbol: "chevron.left.forwardslash.chevron.right",
            view: InterpreterSettings()
        ), Tab(
            name: "Editor",
            symbol: "character.cursor.ibeam",
            view: EditorSettings()
        ), Tab(
            name: "Inspector",
            symbol: "sidebar.trailing",
            view: InspectorSettings()
        ), Tab(
            name: "Export",
            symbol: "square.and.arrow.up.on.square",
            view: ExportSettings()
        )
    ]
    
    var body: some View {
        TabView {
            ForEach(Self.tabs, id: \.name) { tab in
                AnyView(tab.view)
                    .tabItem {
                        Label(tab.name, systemImage: tab.symbol)
                    }
            }
        }
        .frame(width: 490)
        .fixedSize()
    }
}

#Preview {
    SettingsView()
        .environmentObject(settings)
}
