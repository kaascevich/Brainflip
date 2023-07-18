import SwiftUI

struct EditorDefaultsButton: View {
    @EnvironmentObject private var settings: AppSettings
    @State private var isWarningAboutSettingsReset = false
    
    var body: some View {
        Button("Reset Editor Settings...") {
            isWarningAboutSettingsReset = true
        }
        .confirmationDialog("Are you sure you want to reset the edtior to its default settings?", isPresented: $isWarningAboutSettingsReset) {
            Button("Reset") {
                withAnimation {
                    settings.resetEditorToDefaults()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("You cannot undo this action.")
        }
    }
}

#Preview {
    EditorDefaultsButton()
}
