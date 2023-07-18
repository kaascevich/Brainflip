import SwiftUI

struct PointerLocationSlider: View {
    @EnvironmentObject private var settings: AppSettings
    var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimum = 0
        formatter.maximum = NSNumber(floatLiteral: settings.arraySize - 1)
        return formatter
    }
    
    var body: some View {
        Slider(value: settings.$pointerLocation, in: 0...100, step: 5) {
            StepperField(value: settings.$pointerLocation, in: 0...100, label: "Pointer location")
        }
        .help("Controls which cell the pointer starts on when the program begins running; useful for programs which would otherwise require going below the bounds of the array.")
    }
}

private struct PointerLocationSlider_Previews: PreviewProvider {
    static var previews: some View {
        PointerLocationSlider()
            .environmentObject(settings)
    }
}
