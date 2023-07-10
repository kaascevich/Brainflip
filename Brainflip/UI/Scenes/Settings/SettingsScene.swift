import SwiftUI

struct SettingsScene: Scene {
    @StateObject var settings = AppSettings()
    
    var body: some Scene {
        Settings {
            SettingsView()
                .environmentObject(settings)
        }
    }
}
