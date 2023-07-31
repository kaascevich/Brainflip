import SwiftUI

struct LeftHandIncDecToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle(#"Move "++", "--" to left-hand side"#, isOn: settings.$leftHandIncDec)
    }
}

#Preview {
    LeftHandIncDecToggle()
        .environmentObject(settings)
}
