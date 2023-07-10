import SwiftUI

struct SoundSettings: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        VStack(alignment: .trailing) {
            Form {
                Section("Sound Effects") {
                    PlaySoundsToggle()
                }
            }
            .formStyle(.grouped)
            
            SoundDefaultsButton()
                .padding(.horizontal)
                .padding(.bottom)
        }
    }
}

private struct SoundSettings_Previews: PreviewProvider {
    static var previews: some View {
        SoundSettings()
            .environmentObject(AppSettings())
    }
}

