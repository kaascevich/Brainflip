import SwiftUI
import SwiftUIIntrospect

struct TextFieldWithLabel: View {
    var text: String
    let label: String
    @Binding var isTextFieldShown: Bool
    
    
    init(_ text: String, label: String = "", isShown: Binding<Bool>) {
        self.text              = text
        self.label             = label
        self._isTextFieldShown = isShown
    }
    
    var body: some View {
        DisclosureGroup(label, isExpanded: $isTextFieldShown) {
            TextField("", text: .constant(text))
                .monospacedDigit()
                .introspect(.textEditor, on: .macOS(.v14)) {
                    $0.isEditable = false
                    $0.isSelectable = false
                    $0.focusRingType = .none
                }
                .accessibilityLabel(label)
        }
        .disclosureGroupStyle(AnimatedDisclosureGroupStyle())
    }
}

#Preview {
    TextFieldWithLabel(
        "Testing, content",
        label: "Testing, testing",
        isShown: .constant(true)
    )
}
