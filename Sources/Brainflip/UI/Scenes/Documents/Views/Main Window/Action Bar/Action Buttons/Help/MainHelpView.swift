// MainHelpView.swift
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

struct MainHelpView: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openURL) private var openURL
    
    @EnvironmentObject private var settings: AppSettings
    @Bindable var state: AppState
        
    static let helpContent: AttributedString = {
        let fileURL = Bundle.main.url(
            forResource: "MainHelp",
            withExtension: "rtf"
        )!
        
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf]
        
        let string = try! NSAttributedString(
            url: fileURL,
            options: options,
            documentAttributes: nil
        )
        return AttributedString(string)
    }()
    
    
    var body: some View {
        HelpLink {
            state.showingMainHelp.toggle()
        }
        .sheet(isPresented: $state.showingMainHelp) {
            NavigationStack {
                ScrollView {
                    Text(MainHelpView.helpContent)
                        .padding()
                        .textSelection(.enabled)
                }
                .frame(width: 650, height: 400)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            state.showingMainHelp = false
                        }
                    }
                    
                    ToolbarItemGroup(placement: .automatic) {
                        Button("Show ASCII Chart") {
                            openWindow(id: "ascii")
                        }
                        Button("Learn More") {
                            let url = URL(string: "http://brainfuck.org/")!
                            openURL(url)
                        }
                    }
                }
                .navigationTitle("Brainflip Help")
            }
        }
    }
}

#Preview {
    MainHelpView(state: previewState)
        .environmentObject(settings)
}
