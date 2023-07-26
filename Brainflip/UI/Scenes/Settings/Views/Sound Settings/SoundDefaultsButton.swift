import SwiftUI

struct SoundDefaultsButton: View {
    @EnvironmentObject private var settings: AppSettings
    @State private var isWarningAboutSettingsReset = false
    
    var body: some View {
        Button("Reset Sound Settings...") {
            isWarningAboutSettingsReset = true
        }
        .confirmationDialog("Are you sure you want to restore the default sound settings?", isPresented: $isWarningAboutSettingsReset) {
            Button("Reset") {
                withAnimation {
                    settings.resetSoundToDefaults()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("You cannot undo this action.")
        }
    }
}

//#Preview {
//    SoundDefaultsButton()
//        .environmentObject(settings)
//}
