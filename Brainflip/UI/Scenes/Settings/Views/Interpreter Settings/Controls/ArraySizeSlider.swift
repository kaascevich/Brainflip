import SwiftUI

struct ArraySizeSlider: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Slider(value: settings.$arraySize, in: 30_000...60_000, step: 1000) {
            StepperField(value: settings.$arraySize, in: 30_000...60_000, label: "Array size")
        }
        .accessibilityValue(String(settings.arraySize))
        .help("Controls the size of the array.")
    }
}

//#Preview {
//    ArraySizeSlider()
//        .environmentObject(settings)
//}
