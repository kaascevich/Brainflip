import SwiftUI

struct DefaultsButton: View {
    @EnvironmentObject private var settings: AppSettings
    @State private var isWarningAboutReset = false
    
    var body: some View {
        Button("Reset All Settings…") {
            isWarningAboutReset.toggle()
        }
        .confirmationDialog("Are you sure you want to reset all settings to their defaults?", isPresented: $isWarningAboutReset) {
            Button("Reset", role: .destructive) {
                settings.resetAllToDefaults()
            }
            
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("You cannot undo this action.")
        }
    }
}

#Preview {
    DefaultsButton()
        .environmentObject(settings)
}
