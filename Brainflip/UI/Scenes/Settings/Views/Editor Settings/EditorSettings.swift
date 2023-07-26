import SwiftUI

struct EditorSettings: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        VStack(alignment: .trailing) {
            Form {
                Section("Font") {
                    MonospacedToggle()
                    HighlightingToggle()
                    TextSizeSlider()
                }
                Section("Progress") {
                    ShowProgressToggle()
                    ShowCurrentInstructionToggle()
                }
                Section("Other") {
                    ShowProgramSizeToggle()
                }
            }
            .formStyle(.grouped)
            
            EditorDefaultsButton()
                .padding(.horizontal)
                .padding(.bottom)
        }
    }
}

#Preview {
    EditorSettings()
        .environmentObject(settings)
}

