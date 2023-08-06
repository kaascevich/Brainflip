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
    @EnvironmentObject private var settings: AppSettings
    
    typealias Tab = (
        name:   String,
        symbol: String,
        view:   any View
    )
    
    static let tabs: [Tab] = [
        (
            name: "General",
            symbol: "gearshape",
            view: GeneralSettings()
        ), (
            name: "Sound",
            symbol: "volume.3",
            view: SoundSettings()
        ), (
            name: "Interpreter",
            symbol: "chevron.left.forwardslash.chevron.right",
            view: InterpreterSettings()
        ), (
            name: "Editor",
            symbol: "character.cursor.ibeam",
            view: EditorSettings()
        ), (
            name: "Inspector",
            symbol: "sidebar.trailing",
            view: InspectorSettings()
        ), (
            name: "Exporting",
            symbol: "square.and.arrow.up.on.square",
            view: ExportSettings()
        )
    ]
    
    var body: some View {
        TabView {
            ForEach(SettingsView.tabs, id: \.name) { tab in
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
