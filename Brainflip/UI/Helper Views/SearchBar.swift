import SwiftUI
import AppKit

struct SearchBar: NSViewRepresentable {
    typealias NSViewType = NSSearchField
    
    @Binding var searchText: String
             var prompt:     String
    
    init(_ searchText: Binding<String>, prompt: String = "Search") {
        self._searchText = searchText
        self.prompt      = prompt
    }
    
    func makeNSView(context: Context) -> NSViewType {
        let searchField               = NSSearchField()
        searchField.delegate          = context.coordinator
        searchField.placeholderString = prompt
        return searchField
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        nsView.stringValue = searchText
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self, searchText: $searchText)
    }
    
    class Coordinator: NSObject, NSSearchFieldDelegate {
        @Binding var searchText: String
        
        var parent: SearchBar
        
        init(_ parent: SearchBar, searchText: Binding<String>) {
            self.parent      = parent
            self._searchText = searchText
        }
        
        func controlTextDidChange(_ obj: Notification) {
            guard let searchField = obj.object as? NSSearchField else { return }
            searchText = searchField.stringValue
        }
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar(.constant(""))
    }
}

