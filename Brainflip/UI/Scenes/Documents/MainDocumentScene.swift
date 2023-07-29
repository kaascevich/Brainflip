import SwiftUI

struct MainDocumentScene: Scene {
    var body: some Scene {
        DocumentGroup(newDocument: ProgramDocument()) { file in
            let state = ProgramState(document: file.document)
            
            MainDocumentView()
                .frame(minWidth: 735, minHeight: 460)
                .environmentObject(settings)
                .environment(state)
            
            MenuCommandAlerts(state: state)
                .environmentObject(settings)
        }
        .defaultSize(width: 735, height: 460)
        .commands {
            MainMenuCommands()
            ToolbarCommands()
            TextEditingCommands()
        }
        .windowToolbarStyle(.unifiedCompact)
    }
}
