import SwiftUI

struct ProgramSizeView: View {
    @EnvironmentObject private var settings: AppSettings
    @Environment(ProgramState.self) var state: ProgramState
    
    private var programSize: String {
        ByteCountFormatter.string(
            fromByteCount: Int64(state.document.contents.count),
            countStyle: .file
        )
    }
    
    var body: some View {
        Text("Program size: " + programSize)
            .accessibilityRespondsToUserInteraction()
            .accessibilityLabel("Program Size")
            .accessibilityValue(programSize)
    }
}

#Preview {
    ProgramSizeView()
        .environmentObject(settings)
        .environment(previewState)
}
