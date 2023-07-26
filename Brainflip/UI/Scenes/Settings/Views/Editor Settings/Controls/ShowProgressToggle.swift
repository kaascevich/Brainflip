import SwiftUI

struct ShowProgressToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle("Show execution progress", isOn: settings.$showProgress)
    }
}

#Preview {
    ShowProgressToggle()
        .environmentObject(settings)
}
