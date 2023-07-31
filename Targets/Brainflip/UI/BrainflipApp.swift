import Foundation
import SwiftUI

@main
struct BrainflipApp: App {
    var body: some Scene {
        MainDocumentScene()
        ASCIIChartScene()
        SettingsScene()
    }
    
    /// Sets up the app according to the launch arguments.
    init() {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("--ui-testing") {
            settings.resetAllToDefaults()
        }
        #endif
    }
}
