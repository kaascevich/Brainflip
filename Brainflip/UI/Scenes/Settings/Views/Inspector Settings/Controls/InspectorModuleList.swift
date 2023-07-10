import SwiftUI

struct InspectorModuleList: View {
    @EnvironmentObject private var settings: AppSettings
    private var inspector = Inspector()
    
    var body: some View {
        List(settings.$inspectorModuleOrder, editActions: .move, selection: settings.$enabledInspectorModules) { index in
            let index = index.wrappedValue
            Toggle(inspector.modules[index].name, isOn: settings.$enabledInspectorModules[index])
                .help(inspector.modules[index].tooltip)
                .onChange(of: settings.enabledInspectorModules[index]) {
                    settings.expandedInspectorModules[index] = true
                }
        }
        .padding(5)
        .animation(.easeInOut, value: settings.inspectorModuleOrder)
        .animation(.easeInOut, value: settings.enabledInspectorModules)
        
        Toggle("Select All", sources: settings.$enabledInspectorModules, isOn: \.self)
            .toggleStyle(.checkbox)
    }
}

private struct InspectorModuleList_Previews: PreviewProvider {
    static var previews: some View {
        InspectorModuleList()
            .environmentObject(AppSettings())
    }
}
