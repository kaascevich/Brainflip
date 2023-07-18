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
        .help(String(settings.textSize))
    }
}

private struct TextSizeSlider_Previews: PreviewProvider {
    static var previews: some View {
        TextSizeSlider()
            .environmentObject(settings)
    }
}
