import SwiftUI
import Foundation

struct EditorPaneView: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    var body: some View {
        Form {
            HStack {
                Text("Type your program here...")
                    .accessibilityHidden(true)
                Spacer()
                ShowArrayButton(state: state)
                
                if state.isRunningProgram {
                    StopButton(state: state)
                } else {
                    ResetButton(state: state)
                }
            }
            
            Editor(state: state)
            
            HStack {
                if settings.showProgramSize {
                    ProgramSizeView(state: state)
                }
                Spacer()
                ClearMenu(state: state)
            }
        }
    }
}

#Preview {
    EditorPaneView(state: previewState)
        .environmentObject(settings)
}
