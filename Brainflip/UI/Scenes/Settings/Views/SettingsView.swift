import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: AppSettings
    
    typealias Tab = (
        name:   String,
        symbol: String,
        view:   any View
    )
    
    let tabs: [Tab] = [
        (
            name: "General",
            symbol: "gearshape",
            view: GeneralSettings()
        ), (
            name: "Sound",
            symbol: "volume.3",
            view: SoundSettings()
        ), (
            name: "Interpreter",
            symbol: "chevron.left.forwardslash.chevron.right",
            view: InterpreterSettings()
        ), (
            name: "Editor",
            symbol: "character.cursor.ibeam",
            view: EditorSettings()
        ), (
            name: "Inspector",
            symbol: "sidebar.trailing",
            view: InspectorSettings()
        ), (
            name: "Exporting",
            symbol: "square.and.arrow.up.on.square",
            view: ExportSettings()
        )
    ]
    
    var body: some View {
        TabView {
            ForEach(tabs, id: \.name) { tab in
                AnyView(tab.view)
                    .tabItem {
                        Label(tab.name, systemImage: tab.symbol)
                    }
            }
        }
        .frame(width: 490)
        .fixedSize()
    }
}

//#Preview {
//    SettingsView()
//        .environmentObject(settings)
//}
