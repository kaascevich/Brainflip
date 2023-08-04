import SwiftUI

struct MainDocumentScene: Scene {
    var body: some Scene {
        DocumentGroup(newDocument: BrainflipDocument()) { file in
            let state = AppState(document: file.document)
            
            MainDocumentView(state: state)
                .environmentObject(settings)
                .environment(state)
                .focusedSceneValue(\.appState, state)
            
            MenuCommandAlerts(state: state)
                .environmentObject(settings)
        }
        .commands {
            MenuBarCommands()
            ToolbarCommands()
            TextEditingCommands()
        }
        .windowToolbarStyle(.unifiedCompact)
    }
}

extension FocusedValues {
    struct AppStateFocusedValues: FocusedValueKey {
        typealias Value = AppState
    }
    
    var appState: AppState? {
        get {
            self[AppStateFocusedValues.self]
        }
        set {
            self[AppStateFocusedValues.self] = newValue
        }
    }
}
