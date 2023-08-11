// SearchBar.swift
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

import AppKit
import SwiftUI

struct SearchBar: NSViewRepresentable {
    typealias NSViewType = NSSearchField
    
    @Binding var searchText: String
    var prompt: String
    
    init(_ searchText: Binding<String>, prompt: String = "Search") {
        self._searchText = searchText
        self.prompt = prompt
    }
    
    func makeNSView(context: Context) -> NSViewType {
        NSSearchField().then {
            $0.delegate = context.coordinator
            $0.placeholderString = prompt
        }
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        nsView.stringValue = searchText
    }
    
    func makeCoordinator() -> Coordinator {
        .init(self, searchText: $searchText)
    }
    
    class Coordinator: NSObject, NSSearchFieldDelegate {
        @Binding var searchText: String
        
        var parent: SearchBar
        
        init(_ parent: SearchBar, searchText: Binding<String>) {
            self.parent = parent
            self._searchText = searchText
        }
        
        func controlTextDidChange(_ obj: Notification) {
            guard let searchField = obj.object as? NSSearchField else {
                return
            }
            searchText = searchField.stringValue
        }
    }
}

#Preview {
    SearchBar(.constant(""))
}
