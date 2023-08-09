// InspectorModuleList.swift
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

struct InspectorModuleList: View {
    @EnvironmentObject private var settings: AppSettings
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    
    var body: some View {
        List(
            settings.$inspectorModuleOrder,
            id: \.self,
            editActions: .move,
            selection: settings.$enabledInspectorModules
        ) { index in
            let index = index.wrappedValue
            Toggle(Inspector.staticInspector.modules[index].name, isOn: settings.$enabledInspectorModules[index])
                .help(Inspector.staticInspector.modules[index].tooltip)
        }
        .padding(5)
        .animation(reduceMotion ? nil : .smooth, value: settings.inspectorModuleOrder)
        .animation(reduceMotion ? nil : .smooth, value: settings.enabledInspectorModules)
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
