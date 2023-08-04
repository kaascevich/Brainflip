import SwiftUI

struct MonospacedInputToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle("Use monospaced font for input", isOn: settings.$monospacedInput)
    }
}

#Preview {
    MonospacedInputToggle()
        .environmentObject(settings)
}
