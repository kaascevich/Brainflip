import SwiftUI

struct InspectorView: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    @State private var searchText: String = ""
    let inspector: Inspector
    
    init(state: ProgramState) {
        self.state     = state
        self.inspector = Inspector(state: state)
    }
    
    func meetsSearchCriteria(_ string: String) -> Bool {
        searchText.isEmpty ? true : string.lowercased().contains(searchText.lowercased())
    }
    
    var body: some View {
        VStack {
            HStack {
                SearchBar($searchText, prompt: "Find a module")
                Toggle("", sources: settings.$expandedInspectorModules, isOn: \.self)
                    .toggleStyle(DisclosureToggleStyle())
                    .onChange(of: settings.expandedInspectorModules) {
                        settings.expandedInspectorModules.indices.forEach {
                            if !settings.enabledInspectorModules[$0] {
                                settings.expandedInspectorModules[$0] = true
                            }
                        }
                    }
                    .accessibilityLabel(settings.expandedInspectorModules.allSatisfy{ $0 == true } ? "Collapse All" : "Expand All")
            }
            .padding(1)
            
            ScrollView {
                ForEach(settings.inspectorModuleOrder, id: \.self) { index in
                    if settings.enabledInspectorModules[index]
                        && meetsSearchCriteria(inspector.modules[index].name)
                    {
                        TextFieldWithLabel(
                            state.isRunningProgram ? "" : "\(inspector.modules[index].data!)",
                            label: inspector.modules[index].name,
                            isShown: settings.$expandedInspectorModules[index]
                        )
                        .help(inspector.modules[index].tooltip)
                        .padding(.vertical, 2)
                        .animation(.smooth, value: settings.expandedInspectorModules)
                    }
                }
                .animation(.smooth, value: settings.inspectorModuleOrder)
                .animation(.smooth, value: settings.enabledInspectorModules)
            }
            .scrollIndicatorsFlash(onAppear: true)
            .accessibilityLabel("Inspector")
        }
        .padding(10)
        .overlay {
            if inspector.modules.allSatisfy({ !meetsSearchCriteria($0.name) }) {
                ContentUnavailableView.search
            }
        }
    }
}

#Preview {
    InspectorView(state: previewState)
        .environmentObject(settings)
}
