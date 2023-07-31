import SwiftUI

struct MainDocumentScene: Scene {
    var body: some Scene {
        DocumentGroup(newDocument: BrainflipDocument()) { file in
            let state = AppState(document: file.document)
            
            MainDocumentView()
                .frame(minWidth: 735, minHeight: 460)
                .environmentObject(settings)
                .environment(state)
                .focusedSceneValue(\.appState, state)
            
            MenuCommandAlerts(state: state)
                .environmentObject(settings)
        }
        .defaultSize(width: 735, height: 460)
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
