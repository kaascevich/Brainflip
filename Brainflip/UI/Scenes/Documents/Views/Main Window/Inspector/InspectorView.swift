import SwiftUI

struct InspectorView: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    @State private var searchText = ""
    let inspector: Inspector
    init(state: ProgramState) {
        self.state = state
        inspector = Inspector(state: state)
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
                    .onChange(of: settings.expandedInspectorModules) { _ in
                        settings.expandedInspectorModules.indices.forEach {
                            if !settings.enabledInspectorModules[$0] {
                                settings.expandedInspectorModules[$0] = true
                            }
                        }
                    }
            }
            .padding(1)
            
            ScrollView {
                ForEach(settings.inspectorModuleOrder) {
                    if settings.enabledInspectorModules[$0]
                        && meetsSearchCriteria(inspector.modules[$0].name)
                    {
                        TextFieldWithLabel(
                            state.isRunningProgram ? "" : "\(inspector.modules[$0].data!)",
                            label: inspector.modules[$0].name,
                            isShown: settings.$expandedInspectorModules[$0]
                        )
                        .help(inspector.modules[$0].tooltip)
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
            .environmentObject(AppSettings())
    }
}
