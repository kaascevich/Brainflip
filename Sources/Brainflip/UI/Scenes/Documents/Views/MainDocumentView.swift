// MainDocumentView.swift
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

struct MainDocumentView: View {
    @EnvironmentObject private var settings: AppSettings
    @Bindable var state: AppState
    
    var body: some View {
        VSplitView {
            VStack {
                EditorPaneView()
                ActionBarView()
            }
            .padding()
            .frame(minHeight: 310)
            .layoutPriority(1)
            
            if state.isShowingOutput {
                OutputPaneView()
                    .padding()
                    .frame(minHeight: 115)
            }
        }
        .frame(minWidth: 500)
        .inspector(isPresented: $state.isShowingInspector) {
            InspectorPaneView(state: state)
        }
        .toolbar {
            ToolbarContentView()
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    MainDocumentView(state: previewState)
        .environmentObject(settings)
        .environment(previewState)
}
