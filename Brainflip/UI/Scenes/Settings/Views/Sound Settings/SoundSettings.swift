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

//#Preview {
//    SoundSettings()
//        .environmentObject(settings)
//}

