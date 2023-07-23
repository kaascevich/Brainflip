import SwiftUI

struct InputField: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some View {
        TextField("Type your program's input here (type ⌥⏎ or ⇧⏎ for a newline)...", text: $state.input, axis: .vertical)
            .lineLimit(2...2)
            .disabled(state.isRunningProgram)
    }
}

#Preview {
    InputField(state: previewState)
        .environmentObject(settings)
}
