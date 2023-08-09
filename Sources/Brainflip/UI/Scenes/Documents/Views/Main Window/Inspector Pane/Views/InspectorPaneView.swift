// InspectorPaneView.swift
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

struct InspectorPaneView: View {
    @EnvironmentObject private var settings: AppSettings
    var state: AppState
    
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    @SceneStorage("expandedInspectorModules")
    var expandedInspectorModules = Array(repeating: true, count: Inspector.staticInspector.modules.count)
    
    @State private var searchText = ""
    
    func meetsSearchCriteria(_ string: String, query: String) -> Bool {
        query.isEmpty || string.lowercased().contains(query.lowercased())
    }
    
    var body: some View {
        VStack {
            HStack {
                SearchBar($searchText, prompt: "Find a module")
                Toggle("", sources: $expandedInspectorModules, isOn: \.self)
                    .toggleStyle(.disclosure)
                    .accessibilityLabel(expandedInspectorModules.allSatisfy { $0 == true } ? "Collapse All" : "Expand All")
            }
            .padding(1)
            
            ScrollView {
                ForEach(
                    settings.inspectorModuleOrder.filter { settings.enabledInspectorModules[$0] },
                    id: \.self
                ) { index in
                    if meetsSearchCriteria(state.inspector.modules[index].name, query: searchText) {
                        TextFieldWithLabel(
                            state.isRunningProgram ? "" : "\(state.inspector.modules[index].data!)",
                            label: state.inspector.modules[index].name,
                            isShown: $expandedInspectorModules[index]
                        )
                        .help(state.inspector.modules[index].tooltip)
                        .padding(.vertical, 2)
                        .animation(reduceMotion ? nil : .smooth, value: expandedInspectorModules)
                    }
                }
                .animation(reduceMotion ? nil : .smooth, value: settings.inspectorModuleOrder)
                .animation(reduceMotion ? nil : .smooth, value: settings.enabledInspectorModules)
                .disabled(state.isRunningProgram)
            }
            .scrollIndicatorsFlash(onAppear: true)
            .accessibilityLabel("Inspector")
        }
        .padding(10)
        .overlay {
            if state.inspector.modules.allSatisfy({ !meetsSearchCriteria($0.name, query: searchText) }) {
                ContentUnavailableView.search
            }
        }
    }
}

#Preview {
    InspectorPaneView(state: previewState)
        .environmentObject(settings)
}
