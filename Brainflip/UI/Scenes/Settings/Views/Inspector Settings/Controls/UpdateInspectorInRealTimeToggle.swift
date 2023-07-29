import SwiftUI

struct UpdateInspectorInRealTimeToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle("Update inspector modules in real time", isOn: settings.$updateInspectorInRealTime)
    }
}

#Preview {
    UpdateInspectorInRealTimeToggle()
        .environmentObject(settings)
}
