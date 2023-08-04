import SwiftUI

struct MonospacedOutputToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle("Use monospaced font for output", isOn: settings.$monospacedOutput)
    }
}

#Preview {
    MonospacedOutputToggle()
        .environmentObject(settings)
}
