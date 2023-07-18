import SwiftUI

struct ShowCurrentInstructionToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle("Show current instruction", isOn: settings.$showCurrentInstruction)
    }
}

struct ShowCurrentInstructionToggle_Previews: PreviewProvider {
    static var previews: some View {
        ShowCurrentInstructionToggle()
            .environmentObject(settings)
    }
}
