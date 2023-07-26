import SwiftUI

struct ShowCurrentInstructionToggle: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Toggle("Show current instruction", isOn: settings.$showCurrentInstruction)
    }
}

//#Preview {
//    ShowCurrentInstructionToggle()
//        .environmentObject(settings)
//}
