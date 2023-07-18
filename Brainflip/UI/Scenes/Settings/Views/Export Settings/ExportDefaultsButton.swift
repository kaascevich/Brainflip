import SwiftUI

struct ExportDefaultsButton: View {
    @EnvironmentObject private var settings: AppSettings
    @State private var isWarningAboutSettingsReset = false
    
    var body: some View {
        Button("Reset Export Settings...") {
            isWarningAboutSettingsReset = true
        }
        .confirmationDialog("Are you sure you want to restore the default export settings?", isPresented: $isWarningAboutSettingsReset) {
            Button("Reset") {
                withAnimation {
                    settings.resetExportToDefaults()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("You cannot undo this action.")
        }
    }
}

#Preview {
    ExportDefaultsButton()
}
