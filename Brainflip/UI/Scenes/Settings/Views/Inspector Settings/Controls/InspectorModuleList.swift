import SwiftUI

struct InspectorModuleList: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        List(settings.$inspectorModuleOrder, id: \.self, editActions: .move, selection: settings.$enabledInspectorModules) { index in
            let index = index.wrappedValue
            Toggle(Inspector.staticInspector.modules[index].name, isOn: settings.$enabledInspectorModules[index])
                .help(Inspector.staticInspector.modules[index].tooltip)
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
        
        let partitioned = settings.inspectorModuleOrder.partition { !settings.enabledInspectorModules[$0] }
        var enabled  = Array(settings.inspectorModuleOrder[..<partitioned])
        var disabled = Array(settings.inspectorModuleOrder[partitioned...])
        
        let sortPredicate: (Int, Int) -> Bool = { Inspector.staticInspector.modules[$0].name < Inspector.staticInspector.modules[$1].name }
        enabled .sort(by: sortPredicate)
        disabled.sort(by: sortPredicate)
        settings.inspectorModuleOrder = enabled + disabled
    }
}

#Preview {
    InspectorModuleList()
        .environmentObject(settings)
}
