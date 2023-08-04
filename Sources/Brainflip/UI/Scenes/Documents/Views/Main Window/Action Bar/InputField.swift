import SwiftUI
import SwiftUIIntrospect

struct InputField: View {
    @EnvironmentObject private var settings: AppSettings
    @Bindable var state: AppState
    
    @State private var symbolEffect = false
    
    var body: some View {
        HStack {
            TextField("Type your program's input here (type ⌥⏎ or ⇧⏎ for a newline)…", text: $state.input, axis: .vertical)
                .fontDesign(settings.monospacedInput ? .monospaced : .default)
                .lineLimit(3...3)
                .disabled(state.isRunningProgram)
                .accessibilityLabel("Input")
                .speechAlwaysIncludesPunctuation()
                .introspect(.textField, on: .macOS(.v14)) {
                    $0.setAccessibilityPlaceholderValue("Use option-return or shift-return for a newline")
                }
            
            PasteButton(payloadType: String.self) { strings in
                symbolEffect.toggle()
                DispatchQueue.main.async {
                    state.input = strings[0]
                }
            }
            .labelStyle(.iconOnly)
            .controlSize(.large)
            .symbolEffect(.bounce.down, value: symbolEffect)
        }
    }
}

#Preview {
    InputField(state: previewState)
        .environmentObject(settings)
}
