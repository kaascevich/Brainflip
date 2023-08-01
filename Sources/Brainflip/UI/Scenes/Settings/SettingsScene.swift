import SwiftUI

struct SettingsScene: Scene {
    var body: some Scene {
        Settings {
            SettingsView()
                .environmentObject(settings)
        }
    }
}
