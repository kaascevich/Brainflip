import SwiftUI

struct CopyButton: View {
    var action: () -> String
    @State private var symbolEffect = false
    
    init(_ action: @escaping () -> String) {
        self.action = action
    }
    
    var body: some View {
        Button {
            symbolEffect.toggle()
            NSPasteboard.general.clearContents()
            NSPasteboard.general.setString(action(), forType: .string)
        } label: {
            Image(systemName: "doc.on.doc")
                .symbolEffect(.bounce, value: symbolEffect)
        }
        .buttonStyle(.borderless)
    }
}

#Preview {
    CopyButton { "yay, it worked" }
}
