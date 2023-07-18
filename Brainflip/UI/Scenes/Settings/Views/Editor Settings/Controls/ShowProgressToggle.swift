import SwiftUI

struct ShowProgressToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle("Show execution progress", isOn: settings.$showProgress)
    }
}

struct ShowProgressToggle_Previews: PreviewProvider {
    static var previews: some View {
        ShowProgressToggle()
            .environmentObject(settings)
    }
}
