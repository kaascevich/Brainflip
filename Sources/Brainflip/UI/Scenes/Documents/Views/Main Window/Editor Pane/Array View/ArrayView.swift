// ArrayView.swift
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

struct ArrayView: View {
    @EnvironmentObject private var settings: AppSettings
    @Environment(AppState.self) private var state: AppState
    
    var body: some View {
        List {
            ForEach(state.interpreter.cellArray.indices, id: \.self) { index in
                HStack {
                    Text("\(index).")
                        .foregroundColor(state.interpreter.pointer == index ? .green : .primary)
                        .accessibilityLabel("Cell \(index) index")
                        .accessibilityValue(String(index))
                    Spacer()
                    Text(String(state.interpreter.cellArray[index]))
                        .bold()
                        .accessibilityLabel("Cell \(index) value")
                        .accessibilityValue(String(state.interpreter.cellArray[index]))
                        .textSelection(.enabled)
                }
            }
        }
    }
}

#Preview {
    ArrayView()
        .environmentObject(settings)
        .environment(previewState)
}
