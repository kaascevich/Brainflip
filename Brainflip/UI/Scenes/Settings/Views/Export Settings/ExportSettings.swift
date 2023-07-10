import SwiftUI

struct ExportSettings: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        VStack(alignment: .trailing) {
            Form {
                Section("Exporting to C") {
                    ExportPreview()
                    IndentationStepper()
                    PointerNameField()
                    ArrayNameField()
                    LeftHandIncDecToggle()
                    IncludeNotEqualZeroToggle()
                    OpeningBraceBeforeNewLineToggle()
                }
            }
            .formStyle(.grouped)
            
            HStack {
                Spacer()
                WhitespaceList()
                ExportDefaultsButton()
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}

private struct ExportSettings_Previews: PreviewProvider {
    static var previews: some View {
        ExportSettings()
            .environmentObject(AppSettings())
    }
}

