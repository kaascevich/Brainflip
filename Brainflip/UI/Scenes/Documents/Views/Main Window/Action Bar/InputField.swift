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

private struct InputField_Previews: PreviewProvider {
    @State private static var document = ProgramDocument(",[>+<-.]")
    
    static var previews: some View {
        InputField(state: ProgramState(document: document))
            .environmentObject(settings)
    }
}


