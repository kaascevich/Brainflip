import SwiftUI

struct ShowNotificationsToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle("Show notifications", isOn: settings.$showNotifications)
            .onChange(of: settings.showNotifications) {
                if settings.showNotifications {
                    Notifications.requestPermission()
                }
            }
    }
}

struct ShowNotificationsToggle_Previews: PreviewProvider {
    static var previews: some View {
        ShowNotificationsToggle()
            .environmentObject(settings)
    }
}
