// ProgramProgressView.swift
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

struct ProgramProgressView: View {
    @EnvironmentObject private var settings: AppSettings
    @Environment(AppState.self) private var state: AppState
    
    var actualMax: Double {
        Double(state.document.program.count - 1)
    }
    var max: Double {
        Swift.max(1, actualMax)
    }
    var current: Double? {
        guard !state.isRunningProgram else { return nil }
        return min(Swift.max(0, Double(state.interpreter.currentInstructionIndex)), max)
    }
    
    var body: some View {
        HStack {
            Text("0").accessibilityHidden(true)
            
            if state.isRunningProgram {
                ProgressView().progressViewStyle(.linear)
            } else {
                ProgressView(value: current, total: max)
            }
            
            Text("\(Int(actualMax))").accessibilityHidden(true)
        }
    }
}

#Preview {
    ProgramProgressView()
        .environmentObject(settings)
        .environment(previewState)
}
