import SwiftUI

struct InspectorPaneView: View {
    @EnvironmentObject private var settings: AppSettings
    var state: AppState
    
    @SceneStorage("expandedInspectorModules") var expandedInspectorModules: [Bool] = Array(repeating: true, count: Inspector.moduleCount)
    
    @State private var searchText: String = ""
    
    func meetsSearchCriteria(_ string: String, query: String) -> Bool {
        query.isEmpty || string.lowercased().contains(query.lowercased())
    }
    
    var body: some View {
        VStack {
            HStack {
                SearchBar($searchText, prompt: "Find a module")
                Toggle("", sources: $expandedInspectorModules, isOn: \.self)
                    .toggleStyle(DisclosureToggleStyle())
                    .onChange(of: expandedInspectorModules) {
                        expandedInspectorModules.indices.forEach {
                            if !settings.enabledInspectorModules[$0] {
                                expandedInspectorModules[$0] = true
                            }
                        }
                    }
                    .accessibilityLabel(expandedInspectorModules.allSatisfy { $0 == true } ? "Collapse All" : "Expand All")
            }
            .padding(1)
            
            ScrollView {
                ForEach(settings.inspectorModuleOrder.filter { settings.enabledInspectorModules[$0] }, id: \.self) { index in
                    if settings.enabledInspectorModules[index]
                        && meetsSearchCriteria(state.inspector.modules[index].name, query: searchText)
                    {
                        TextFieldWithLabel(
                            state.isRunningProgram ? "" : "\(state.inspector.modules[index].data!)",
                            label: state.inspector.modules[index].name,
                            isShown: $expandedInspectorModules[index]
                        )
                        .help(state.inspector.modules[index].tooltip)
                        .padding(.vertical, 2)
                        .animation(.smooth, value: expandedInspectorModules)
                    }
                }
                .animation(.smooth, value: settings.inspectorModuleOrder)
                .animation(.smooth, value: settings.enabledInspectorModules)
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
