import SwiftUI

struct MainMenuCommands: Commands {
    var body: some Commands {
        FileCommands()
        EditCommands()
        ViewCommands()
        HelpCommands()
        ProgramCommands()
    }
}
