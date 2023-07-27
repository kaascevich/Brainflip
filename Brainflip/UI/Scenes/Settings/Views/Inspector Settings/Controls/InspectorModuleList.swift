import SwiftUI

struct InspectorModuleList: View {
    @EnvironmentObject private var settings: AppSettings
    private var inspector = Inspector()
    
    var body: some View {
        List(settings.$inspectorModuleOrder, id: \.self, editActions: .move, selection: settings.$enabledInspectorModules) { index in
            let index = index.wrappedValue
            Toggle(inspector.modules[index].name, isOn: settings.$enabledInspectorModules[index])
                .help(inspector.modules[index].tooltip)
                .onChange(of: settings.enabledInspectorModules[index]) {
                    settings.expandedInspectorModules[index] = true
                }
        }
        .padding(5)
        .animation(.smooth, value: settings.inspectorModuleOrder)
        .animation(.smooth, value: settings.enabledInspectorModules)
        .accessibilityLabel("Inspector Modules")
        
        HStack {
            Toggle("Select All", sources: settings.$enabledInspectorModules, isOn: \.self)
                .toggleStyle(.checkbox)
            Spacer()
            Button("Sort") {
                sortModules()
            }
        }
    }
    
    func sortModules() {
        // The end goal here is to first partition the module array into two halves, with
        // enabled modules above disabled ones, and then sort each partition alphabetically.
        //
        // partition(by:) is perfect for the former, with one tiny issue: the array ordering
        // is not preserved during the partition. So we have to manually split the array into
        // the two halves, sort those, and then merge them back together before committing
        // the changes to settings.inspectorModuleOrder.
        
        let p = settings.inspectorModuleOrder.partition { !settings.enabledInspectorModules[$0] }
        var arrays = (
            Array(settings.inspectorModuleOrder[..<p]),
            Array(settings.inspectorModuleOrder[p...])
        )
        arrays.0.sort { inspector.modules[$0].name < inspector.modules[$1].name }
        arrays.1.sort { inspector.modules[$0].name < inspector.modules[$1].name }
        settings.inspectorModuleOrder = arrays.0 + arrays.1
    }
}

#Preview {
    InspectorModuleList()
        .environmentObject(settings)
}
