import SwiftUI
import Foundation

struct EditorView: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    var body: some View {
        Form {
            HStack {
                Text("Type your program here...")
                Spacer()
                ShowArrayButton(state: state)
                ResetButton(state: state)
            }
            
            Editor(state: state)
            
            HStack {
                if settings.showProgramSize {
                    Text("Program size: \(ByteCountFormatter.string(fromByteCount: Int64(state.document.contents.count), countStyle: .file))")
                }
                Spacer()
                ClearMenu(state: state)
                    .frame(width: 65)
            }
        }
    }
}

#Preview {
    EditorView(state: previewState)
        .environmentObject(settings)
}
