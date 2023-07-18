import SwiftUI

struct ShowTimerToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle("Show timer", isOn: settings.$showTimer)
    }
}

#Preview {
    ShowTimerToggle()
}
