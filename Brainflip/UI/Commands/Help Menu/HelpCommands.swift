import SwiftUI

struct HelpCommands: Commands {
    @FocusedObject<ProgramState> var state
    
    var body: some Commands {
        CommandGroup(replacing: .help) {
            Button("Brainflip Help") {
                state?.showingMainHelp = true
            }
            .disabled(state == nil)
            
            Link("Algorithms...", destination: URL(string: "https://esolangs.org/wiki/Brainfuck_algorithms")!)
        }
    }
}
