import SwiftUI
import Foundation

struct EditorPaneView: View {
    @EnvironmentObject private var settings: AppSettings
    @Environment(\.appState) private var state: AppState
    
    var body: some View {
        Form {
            HStack {
                Text("Type your program here...")
                    .accessibilityHidden(true)
                Spacer()
                ShowArrayButton(state: state)
                
                if state.isRunningProgram {
                    StopButton()
                } else {
                    ResetButton()
                }
            }
            
            Editor(state: state)
            
            HStack {
                if settings.showProgramSize {
                    ProgramSizeView()
                }
                Spacer()
                ClearMenu(state: state)
            }
        }
    }
}

#Preview {
    EditorPaneView()
        .environmentObject(settings)
        .environment(previewState)
}
