import SwiftUI

struct CopyButton: View {
    var textToCopy: () -> String
    @State private var symbolEffect = false
    
    init(_ textToCopy: @escaping () -> String) {
        self.textToCopy = textToCopy
    }
    
    var body: some View {
        Button {
            symbolEffect.toggle()
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(textToCopy(), forType: .string)
        } label: {
            Label("Copy", systemImage: "doc.on.doc")
                .symbolEffect(.bounce.down, value: symbolEffect)
        }
    }
}

#Preview {
    CopyButton { "yay, it worked" }
}
