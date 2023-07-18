import SwiftUI

struct ArraySizeSlider: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Slider(value: settings.$arraySize, in: 30_000...60_000, step: 1000) {
            StepperField(value: settings.$arraySize, in: 30_000...60_000, label: "Array size")
        }
        .help("Controls the size of the array.")
    }
}

private struct ArraySizeSlider_Previews: PreviewProvider {
    static var previews: some View {
        ArraySizeSlider()
            .environmentObject(settings)
    }
}
