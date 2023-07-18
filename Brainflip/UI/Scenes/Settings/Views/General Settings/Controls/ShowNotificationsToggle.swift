import SwiftUI

struct ShowNotificationsToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle("Show notifications", isOn: settings.$showNotifications)
    }
}

struct NotificationsToggle_Previews: PreviewProvider {
    static var previews: some View {
        ShowNotificationsToggle()
            .environmentObject(settings)
    }
}
