import SwiftUI

struct DefaultsButton: View {
    @EnvironmentObject private var settings: AppSettings
    @State private var isWarningAboutReset = false
    
    @State private var confirmationInput = ""
    
    private let appName = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as! String

    var body: some View {
        Button("Reset All Settings…") {
            isWarningAboutReset.toggle()
        }
        .confirmationDialog("Are you sure you want to reset all settings to their defaults?", isPresented: $isWarningAboutReset) {
            TextField("Type \"\(appName)\" to reset", text: $confirmationInput)
            
            Button("Reset", role: .destructive) {
                settings.resetAllToDefaults()
            }
            .disabled(confirmationInput != appName)
            
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Type \"\(appName)\" to confirm your intent. You cannot undo this action.")
        }
    }
}

#Preview {
    DefaultsButton()
        .environmentObject(settings)
}
