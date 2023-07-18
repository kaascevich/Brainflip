import AppIntents

struct IntentProvider: AppShortcutsProvider {
    static var shortcutTileColor: ShortcutTileColor = .lime
    
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: RunBFProgramIntent(),
            phrases: [
                "Run \(.applicationName) program",
                "Run \(.applicationName) code",
                "Execute \(.applicationName) program",
                "Execute \(.applicationName) code",
            ],
            shortTitle: "Run Brainflip program",
            systemImageName: "chevron.left.forwardslash.chevron.right"
        )
    }
}
