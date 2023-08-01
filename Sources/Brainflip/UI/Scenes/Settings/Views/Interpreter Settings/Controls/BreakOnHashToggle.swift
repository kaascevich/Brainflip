import SwiftUI

struct BreakOnHashToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle("Stop on break instruction", isOn: settings.$breakOnHash)
            .help("Controls whether the program stops running upon encountering a break instruction.")
    }
}

#Preview {
    BreakOnHashToggle()
        .environmentObject(settings)
}
