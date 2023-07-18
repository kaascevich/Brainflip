import SwiftUI

struct InspectorSettings: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        VStack(alignment: .trailing) {
            Form {
                Section {
                    InspectorModuleList()
                } header: {
                    Text("Inspector Modules")
                    Text("Drag modules to reorder them.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .formStyle(.grouped)
            
            InspectorDefaultsButton()
                .padding(.horizontal)
                .padding(.bottom)
        }
    }
}

private struct InspectorSettings_Previews: PreviewProvider {
    static var previews: some View {
        InspectorSettings()
            .environmentObject(settings)
    }
}

