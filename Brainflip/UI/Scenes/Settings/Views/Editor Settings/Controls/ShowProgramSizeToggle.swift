import SwiftUI

struct ShowProgramSizeToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle("Show program size", isOn: settings.$showProgramSize)
    }
}

//#Preview {
//    ShowProgramSizeToggle()
//        .environmentObject(settings)
//}
