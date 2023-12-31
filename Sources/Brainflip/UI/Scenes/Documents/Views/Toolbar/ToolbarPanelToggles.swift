// ToolbarPanelToggles.swift
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

struct ToolbarPanelToggles: ToolbarContent {
    @Bindable var state: AppState
    
    var body: some ToolbarContent {
        ToolbarItemGroup {
            Toggle(isOn: $state.isShowingOutput) {
                Label(
                    state.isShowingOutput ? "Hide Output" : "Show Output",
                    systemImage: #symbol("square.bottomthird.inset.filled")
                )
                .symbolEffect(.bounce.down, value: state.isShowingOutput)
            }
            Toggle(isOn: $state.isShowingInspector) {
                Label(
                    state.isShowingInspector ? "Hide Inspector" : "Show Inspector",
                    systemImage: #symbol("square.trailingthird.inset.filled")
                )
                .symbolEffect(.bounce.down, value: state.isShowingInspector)
            }
        }
     }
}
