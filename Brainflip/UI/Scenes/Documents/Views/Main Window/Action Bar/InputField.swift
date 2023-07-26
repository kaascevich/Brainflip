import SwiftUI

struct InputField: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    @State private var symbolEffect = false
    
    var body: some View {
        HStack {
            TextField("Type your program's input here (type ⌥⏎ or ⇧⏎ for a newline)...", text: $state.input, axis: .vertical)
                .lineLimit(2...2)
                .disabled(state.isRunningProgram)
                .accessibilityLabel("Input")
                .speechAlwaysIncludesPunctuation()
            
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

//#Preview {
//    InputField(state: previewState)
//        .environmentObject(settings)
//}
