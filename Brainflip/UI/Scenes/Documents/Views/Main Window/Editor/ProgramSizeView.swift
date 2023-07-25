import SwiftUI

<<<<<<< HEAD
struct ProgramSizeView: View {
=======
struct StopButton: View {
>>>>>>> 563b6a557e75a6a4c1cff9e89e0e937a4dd45412
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some View {
<<<<<<< HEAD
        Text("Program size: " + ByteCountFormatter.string(
            fromByteCount: Int64(state.document.contents.count),
            countStyle: .file
        ))
=======
        Button {
            state.stop()
        } label: {
            Text("Stop")
                .frame(width: 35)
        }
        .disabled(state.disableStopButton)
>>>>>>> 563b6a557e75a6a4c1cff9e89e0e937a4dd45412
    }
}

#Preview {
<<<<<<< HEAD
    ProgramSizeView(state: previewState)
=======
    StopButton(state: previewState)
>>>>>>> 563b6a557e75a6a4c1cff9e89e0e937a4dd45412
        .environmentObject(settings)
}
