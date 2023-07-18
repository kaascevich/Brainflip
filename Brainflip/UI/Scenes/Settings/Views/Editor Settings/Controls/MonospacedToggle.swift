import SwiftUI

struct MonospacedToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle("Use monospaced font", isOn: settings.$monospaced)
    }
}

struct MonospacedToggle_Previews: PreviewProvider {
    static var previews: some View {
        MonospacedToggle()
            .environmentObject(settings)
    }
}
