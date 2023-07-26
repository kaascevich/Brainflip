import SwiftUI

struct IncludeVoidWithinMainToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle(#"Include "void" within "main()" declaration"#, isOn: settings.$includeVoidWithinMain)
    }
}

//#Preview {
//    IncludeVoidWithinMainToggle()
//        .environmentObject(settings)
//}
