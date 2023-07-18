import SwiftUI

struct OpeningBraceBeforeNewLineToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle("Add a new line before opening braces", isOn: settings.$openingBraceOnNewLine)
    }
}

#Preview {
    OpeningBraceBeforeNewLineToggle()
}
