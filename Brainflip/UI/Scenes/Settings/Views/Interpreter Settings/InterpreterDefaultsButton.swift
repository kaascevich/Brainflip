import SwiftUI

struct InterpreterDefaultsButton: View {
    @EnvironmentObject private var settings: AppSettings
    
    @State private var isWarningAboutSettingsReset = false
    
    var body: some View {
        Button("Reset Interpreter Settings...") {
            isWarningAboutSettingsReset = true
        }
        .confirmationDialog("Are you sure you want to reset the interpreter to its default settings?", isPresented: $isWarningAboutSettingsReset) {
            Button("Reset") {
                withAnimation {
                    settings.resetInterpreterToDefaults()
                }
            }
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("You cannot undo this action.")
        }
    }
}

#Preview {
    InterpreterDefaultsButton()
        .environmentObject(settings)
}
