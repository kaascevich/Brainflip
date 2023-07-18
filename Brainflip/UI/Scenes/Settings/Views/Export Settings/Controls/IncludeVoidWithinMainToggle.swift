import SwiftUI

struct IncludeVoidWithinMainToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle(#"Include "void" within "main()" declaration"#, isOn: settings.$includeVoidWithinMain)
    }
}

struct IncludeVoidWithinMainToggle_Previews: PreviewProvider {
    static var previews: some View {
        IncludeVoidWithinMainToggle()
            .environmentObject(settings)
    }
}
