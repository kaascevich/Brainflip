import SwiftUI

struct ShowTimerToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle("Show timer", isOn: settings.$showTimer)
    }
}

struct ShowTimerToggle_Previews: PreviewProvider {
    static var previews: some View {
        ShowTimerToggle()
            .environmentObject(AppSettings())
    }
}
