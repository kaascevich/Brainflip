import SwiftUI

struct PlaySoundsToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle("Play sound effects", isOn: settings.$playSounds)
        
        Section {
            Toggle("When running program", isOn: settings.$playStartSound)
            Toggle("When program finishes running", isOn: settings.$playSuccessSound)
            Toggle("When program stops with an error", isOn: settings.$playFailSound)
            Toggle("When stepping through program", isOn: settings.$playStepSound)
        }
        .disabled(!settings.playSounds)
    }
}

#Preview {
    PlaySoundsToggle()
}
