import SwiftUI

struct MainDocumentView: View {
    @EnvironmentObject private var settings: AppSettings
    @StateObject var state: ProgramState
    
    init(state: ProgramState) {
        self._state = StateObject(wrappedValue: state)
    }
    
    var body: some View {
        HSplitView {
            VSplitView {
                VStack {
                    EditorPaneView(state: state)
                    ActionBarView(state: state)
                }
                .padding()
                .frame(minWidth: 500, maxWidth: .infinity, minHeight: 310, maxHeight: .infinity)
                .layoutPriority(1)
                
                if state.isShowingOutput {
                    OutputPaneView(state: state)
                        .padding()
                        .frame(minWidth: 500, maxWidth: .infinity, minHeight: 115, maxHeight: .infinity)
                }
            }
            .layoutPriority(1)
            .focusedSceneObject(state)
            
            if state.isShowingInspector {
                InspectorPaneView(state: state)
                    .frame(minWidth: 235, maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .toolbar {
            ToolbarContentView(state: state)
        }
    }
}

#Preview {
    MainDocumentView(state: previewState)
        .environmentObject(settings)
}
