import SwiftUI

struct ProgramSizeView: View {
    @EnvironmentObject private var settings: AppSettings
    @Environment(AppState.self) private var state: AppState
    
    private var programSize: String {
        ByteCountFormatter.string(
            fromByteCount: Int64(state.document.contents.count),
            countStyle: .file
        )
        + ", "
        + ByteCountFormatter.string(
            fromByteCount: Int64(state.document.program.count - 1),
            countStyle: .file
        )
        + " executable"
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
