import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        TabView {
            GeneralSettings()
                .tabItem {
                    Label("General", systemImage: "gearshape")
                }
            SoundSettings()
                .tabItem {
                    Label("Sound", systemImage: "volume.3")
                }
            InterpreterSettings()
                .tabItem {
                    Label("Interpreter", systemImage: "chevron.left.forwardslash.chevron.right")
                }
            EditorSettings()
                .tabItem {
                    Label("Editor", systemImage: "character.cursor.ibeam")
                }
            InspectorSettings()
                .tabItem {
                    Label("Inspector", systemImage: "sidebar.trailing")
                }
            ExportSettings()
                .tabItem {
                    Label("Exporting", systemImage: "square.and.arrow.up.on.square")
                }
        }
        .frame(width: 490)
        .fixedSize()
    }
}

#Preview {
    SettingsView()
        .environmentObject(settings)
}
