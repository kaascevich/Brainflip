import SwiftUI

struct ProgramSizeView: View {
    @EnvironmentObject private var settings: AppSettings
    @Environment(AppState.self) private var state: AppState
    
    private var programSize: String {
        let byteCountFormatStyle = ByteCountFormatStyle(
            style: .file,
            allowedUnits: .bytes,
            spellsOutZero: false
        )
        
        let fullByteCount = (state.document.contents.utf8.count).formatted(byteCountFormatStyle)
        let executableByteCount = (state.document.program.count - 1).formatted(byteCountFormatStyle)
        
        return "\(fullByteCount), \(executableByteCount) executable"
    }
    
    var body: some View {
        Text("Program size: \(programSize)")
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
