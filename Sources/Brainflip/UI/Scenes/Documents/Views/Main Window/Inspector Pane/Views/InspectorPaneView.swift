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
    @State private var searchText = ""
    
    @SceneStorage("expandedInspectorModules")
    var expandedInspectorModules = Array(repeating: true, count: Inspector.modules.count)

    func meetsSearchCriteria(_ string: String, query: String) -> Bool {
        query.isEmpty || string.lowercased().contains(query.lowercased())
    }
    
    var inspectorAnimation: Animation? {
        @Environment(\.accessibilityReduceMotion) var reduceMotion
        return reduceMotion ? nil : .smooth
    }
    
    var body: some View {
        VStack {
            HStack {
                SearchBar($searchText, prompt: "Find a module")
                Toggle("", sources: $expandedInspectorModules, isOn: \.self)
                    .toggleStyle(.disclosure)
                    .accessibilityLabel(
                        expandedInspectorModules.allSatisfy { $0 == true } ? "Collapse All" : "Expand All"
                    )
            }
            .padding(1)
            
            ScrollView {
                ForEach(
                    settings.inspectorModuleOrder.filter { settings.enabledInspectorModules[$0] },
                    id: \.self
                ) { index in
                    if meetsSearchCriteria(Inspector.modules[index].name, query: searchText) {
                        TextFieldWithLabel(
                            state.isRunningProgram ? "" : Inspector.modules[index].data(from: state.interpreter),
                            label: Inspector.modules[index].name,
                            isShown: $expandedInspectorModules[index]
                        )
                        .help(Inspector.modules[index].tooltip)
                        .padding(.vertical, 2)
                        .animation(inspectorAnimation, value: expandedInspectorModules)
                    }
                }
                .animation(inspectorAnimation, value: settings.inspectorModuleOrder)
                .animation(inspectorAnimation, value: settings.enabledInspectorModules)
                .disabled(state.isRunningProgram)
            }
            .scrollIndicatorsFlash(onAppear: true)
            .accessibilityLabel("Inspector")
        }
        .padding(10)
        .overlay {
            // Only show it if NONE of the modules meet the criteria
            if Inspector.modules.allSatisfy({ !meetsSearchCriteria($0.name, query: searchText) }) {
                ContentUnavailableView.search
            }
        }
    }
}

#Preview {
    InspectorPaneView(state: previewState)
        .environmentObject(settings)
}
