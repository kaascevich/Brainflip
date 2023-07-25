import SwiftUI

struct ProgramSizeView: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some View {
        Text("Program size: " + ByteCountFormatter.string(
            fromByteCount: Int64(state.document.contents.count),
            countStyle: .file
        ))
    }
}

#Preview {
    ProgramSizeView(state: previewState)
        .environmentObject(settings)
}
