// WhitespaceList.swift
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

struct WhitespaceList: View {
    @EnvironmentObject private var settings: AppSettings
    @State private var isShowingWhitespaceSettings = false
    
    typealias Whitespace = BrainflipToC.Whitespace
        
    var body: some View {
        Button("Whitespace…") {
            isShowingWhitespaceSettings.toggle()
        }
        .sheet(isPresented: $isShowingWhitespaceSettings) {
            Form {
                Section("Show whitespace:") {
                    List(Whitespace.allCases.indices, id: \.self) {
                        Toggle(Whitespace.allCases[$0].rawValue, isOn: Whitespace.$enabledWhitespace[$0])
                    }
                    .padding(5)
                }
            }
            .formStyle(.grouped)
            .frame(width: 390, height: 414)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        isShowingWhitespaceSettings = false
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

#Preview {
    WhitespaceList()
        .environmentObject(settings)
}
