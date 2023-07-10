import SwiftUI

struct InspectorDefaultsButton: View {
    @EnvironmentObject private var settings: AppSettings
    
    @State private var isWarningAboutSettingsReset = false
    
    var body: some View {
        Button("Reset Inspector Settings...") {
            isWarningAboutSettingsReset = true
        }
        .confirmationDialog("Are you sure you want to reset the inspector to its default settings?", isPresented: $isWarningAboutSettingsReset) {
            Button("Reset") {
                withAnimation {
                    settings.resetInspectorToDefaults()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("You cannot undo this action.")
        }
    }
}

private struct InspectorDefaultsButton_Previews: PreviewProvider {
    static var previews: some View {
        InspectorDefaultsButton()
            .environmentObject(AppSettings())
    }
}
