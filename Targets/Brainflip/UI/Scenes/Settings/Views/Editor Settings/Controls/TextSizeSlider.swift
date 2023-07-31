import SwiftUI

struct TextSizeSlider: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Slider(value: settings.$textSize, in: 1...100) {
            StepperField(value: settings.$textSize, in: 1...100, label: "Text size")
        } minimumValueLabel: {
            Image(systemName: "textformat.size.smaller")
        } maximumValueLabel: {
            Image(systemName: "textformat.size.larger")
        }
        .accessibilityValue(String(settings.textSize))
        .help(String(settings.textSize))
    }
}

#Preview {
    TextSizeSlider()
        .environmentObject(settings)
}
