import SwiftUI

struct HelpCommands: Commands {
    @FocusedValue(\.appState) private var state
    
    var body: some Commands {
        CommandGroup(replacing: .help) {
            Button("Brainflip Help") {
                state?.showingMainHelp = true
            }
            .disabled(state == nil || state!.disableMenuItems)
            .accessibilityIdentifier("revealHelpContent:")
            
            Link("Algorithms…", destination: URL(string: "https://esolangs.org/wiki/Brainfuck_algorithms")!)
                .accessibilityIdentifier("revealAlgorithmsWebPage:")
        }
    }
}
