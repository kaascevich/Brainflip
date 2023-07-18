import SwiftUI

struct OpeningBraceBeforeNewLineToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle("Add a new line before opening braces", isOn: settings.$openingBraceOnNewLine)
    }
}

struct OpeningBraceBeforeNewLineToggle_Previews: PreviewProvider {
    static var previews: some View {
        OpeningBraceBeforeNewLineToggle()
            .environmentObject(settings)
    }
}
