import SwiftUI
import Introspect

struct TextFieldWithLabel: View {
    var text: String
    let label: String
    @Binding var isTextFieldShown: Bool
    init(_ text: String, label: String = "", isShown: Binding<Bool>) {
        self.text = text
        self.label = label
        _isTextFieldShown = isShown
    }
    
    var body: some View {
        DisclosureGroup(label, isExpanded: $isTextFieldShown) {
            TextField("", text: .constant(text))
                .font(.body.monospacedDigit())
                .introspectTextField {
                    $0.isEditable = false
                }
        }
        .disclosureGroupStyle(AnimatedDisclosureGroupStyle())
    }
}

private struct TextFieldWithLabel_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldWithLabel("Testing, testing", label: "Testing, testing", isShown: .constant(true))
    }
}
