import SwiftUI

struct DefaultsButton: View {
    @EnvironmentObject private var settings: AppSettings
    @State private var isWarningAboutSettingsReset = false
    
    var body: some View {
        Button("Reset All Settings...") {
            isWarningAboutSettingsReset = true
        }
        .confirmationDialog("Are you sure you want to reset all settings to their defaults?", isPresented: $isWarningAboutSettingsReset) {
            Button("Reset", role: .destructive) {
                withAnimation {
                    settings.resetAllToDefaults()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("You cannot undo this action.")
        }
    }
}

private struct DefaultsButton_Previews: PreviewProvider {
    static var previews: some View {
        DefaultsButton()
            .environmentObject(settings)
    }
}
