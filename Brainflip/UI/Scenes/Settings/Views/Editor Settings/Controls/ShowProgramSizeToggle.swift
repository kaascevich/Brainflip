import SwiftUI

struct ShowProgramSizeToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle("Show program size", isOn: settings.$showProgramSize)
    }
}

struct ShowProgramSizeToggle_Previews: PreviewProvider {
    static var previews: some View {
        ShowProgramSizeToggle()
            .environmentObject(settings)
    }
}
