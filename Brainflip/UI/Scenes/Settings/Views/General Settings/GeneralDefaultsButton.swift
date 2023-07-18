import SwiftUI

struct GeneralDefaultsButton: View {
    @EnvironmentObject private var settings: AppSettings
    @State private var isWarningAboutSettingsReset = false
    
    var body: some View {
        Button("Reset General Settings...") {
            isWarningAboutSettingsReset = true
        }
        .confirmationDialog("Are you sure you want to restore the default general settings?", isPresented: $isWarningAboutSettingsReset) {
            Button("Reset") {
                withAnimation {
                    settings.resetGeneralToDefaults()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("You cannot undo this action.")
        }
    }
}

#Preview {
    GeneralDefaultsButton()
}
