import SwiftUI

struct HighlightingToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle("Enable syntax highlighting", isOn: settings.$highlighting)
    }
}

//#Preview {
//    HighlightingToggle()
//        .environmentObject(settings)
//}
