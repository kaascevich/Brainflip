import SwiftUI

struct IncludeNotEqualZeroToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle(#"Include "!= 0" in "while" statements"#, isOn: settings.$includeNotEqualZero)
    }
}

struct IncludeNotEqualZeroToggle_Previews: PreviewProvider {
    static var previews: some View {
        IncludeNotEqualZeroToggle()
            .environmentObject(settings)
    }
}
