import SwiftUI

struct IndentationStepper: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        StepperField(value: settings.$indentation, in: 0...10, label: "Indentation")
    }
}

#Preview {
    IndentationStepper()
}
