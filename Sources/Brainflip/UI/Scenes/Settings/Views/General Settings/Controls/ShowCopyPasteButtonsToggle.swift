import SwiftUI

struct ShowCopyPasteButtonsToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle("Show copy and paste buttons", isOn: settings.$showCopyPasteButtons)
    }
}

#Preview {
    ShowCopyPasteButtonsToggle()
        .environmentObject(settings)
}
