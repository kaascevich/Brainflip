import SwiftUI

struct InterpreterSettings: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        VStack(alignment: .trailing) {
            Form {
                Text("Changing these settings will break compatibility with many programs. It is recommended to leave them at their defaults.")
                Section("Interpreter Settings") {
                    EndOfFilePicker()
                    ArraySizeSlider()
                    PointerLocationSlider()
                    CellSizePicker()
                    BreakOnHashToggle()
                }
            }
            .formStyle(.grouped)
            
            InterpreterDefaultsButton()
                .padding(.horizontal)
                .padding(.bottom)
        }
    }
}

private struct InterpreterSettings_Previews: PreviewProvider {    
    static var previews: some View {
        InterpreterSettings()
            .environmentObject(AppSettings())
    }
}

