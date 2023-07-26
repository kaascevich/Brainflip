import SwiftUI

struct IncludeNotEqualZeroToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle(#"Include "!= 0" in "while" statements"#, isOn: settings.$includeNotEqualZero)
    }
}

//#Preview {
//    IncludeNotEqualZeroToggle()
//        .environmentObject(settings)
//}
