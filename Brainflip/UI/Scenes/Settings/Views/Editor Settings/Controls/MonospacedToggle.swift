import SwiftUI

struct MonospacedToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle("Use monospaced font", isOn: settings.$monospaced)
    }
}

//#Preview {
//    MonospacedToggle()
//        .environmentObject(settings)
//}
