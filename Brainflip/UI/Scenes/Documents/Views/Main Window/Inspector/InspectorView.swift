import SwiftUI

struct InspectorView: View {
    @EnvironmentObject private var settings:              AppSettings
    @ObservedObject            var state:                 ProgramState
    @State             private var searchText:            String = ""
                               let inspector:             Inspector
    
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
            }
            .padding(1)
            
            ScrollView {
                ForEach(settings.inspectorModuleOrder) { index in
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
                        .animation(.easeInOut, value: settings.expandedInspectorModules)
                    }
                }
                .animation(.easeInOut, value: settings.inspectorModuleOrder)
                .animation(.easeInOut, value: settings.enabledInspectorModules)
            }
            .scrollIndicatorsFlash(onAppear: true)
        }
        .padding(10)
    }
}

private struct InspectorView_Previews: PreviewProvider {
    @State private static var document = ProgramDocument(",[>+<-.]")
    
    static var previews: some View {
        InspectorView(state: ProgramState(document: document))
            .environmentObject(settings)
    }
}
