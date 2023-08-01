import SwiftUI

struct MenuBarCommands: Commands {
    var body: some Commands {
        FileCommands()
        EditCommands()
        ViewCommands()
        HelpCommands()
        ProgramCommands()
    }
}
