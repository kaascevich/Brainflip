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

//#Preview {
//    ShowNotificationsToggle()
//        .environmentObject(settings)
//}
