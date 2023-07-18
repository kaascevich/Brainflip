import SwiftUI

struct GeneralSettings: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        VStack(alignment: .trailing) {
            Form {
                Section("Timer") {
                    ShowTimerToggle()
                }
                Section("Notifications") {
                    ShowNotificationsToggle()
                }
            }
            .formStyle(.grouped)
            
            HStack {
                GeneralDefaultsButton()
                DefaultsButton()
            }
                .padding(.horizontal)
                .padding(.bottom)
        }
    }
}

#Preview {
    GeneralSettings()
}

