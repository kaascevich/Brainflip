import SwiftUI

struct LeftHandIncDecToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle(#"Move "++", "--" to left-hand side"#, isOn: settings.$leftHandIncDec)
    }
}

struct LeftHandIncDecToggle_Previews: PreviewProvider {
    static var previews: some View {
        LeftHandIncDecToggle()
            .environmentObject(AppSettings())
    }
}
