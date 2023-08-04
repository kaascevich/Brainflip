import SwiftUI
import SwiftUIIntrospect

struct InputField: View {
    @EnvironmentObject private var settings: AppSettings
    @Bindable var state: AppState
    
    @State private var symbolEffect = false
    
    var body: some View {
        HStack {
            TextField(
                "Type your program's input here (type ⌥⏎ or ⇧⏎ for a newline)…",
                text: $state.input,
                axis: .vertical
            )
            .fontDesign(settings.monospacedInput ? .monospaced : .default)
            .lineLimit(3, reservesSpace: true)
            .disabled(state.isRunningProgram)
            .accessibilityLabel("Input")
            .speechAlwaysIncludesPunctuation()
            .introspect(.textField, on: .macOS(.v14)) {
                $0.setAccessibilityPlaceholderValue("Use option-return or shift-return for a newline")
            }
            .onSubmit {
                state.run()
            }
            
            if settings.showCopyPasteButtons {
                VStack {
                    CopyButton { state.input }
                        .help("Copy")
                    
                    PasteButton(payloadType: String.self) { strings in
                        symbolEffect.toggle()
                        DispatchQueue.main.async {
                            state.input = strings[0]
                        }
                    }
                    .symbolEffect(.bounce.down, value: symbolEffect)
                    .help("Paste")
                }
                .labelStyle(.iconOnly)
                .buttonStyle(.borderless)
            }
        }
    }
}

#Preview {
    InputField(state: previewState)
        .environmentObject(settings)
}
