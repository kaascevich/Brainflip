import SwiftUI

struct MainDocumentView: View {
    @EnvironmentObject private var settings: AppSettings
    @Environment(AppState.self) private var state: AppState
    
    var body: some View {
        HSplitView {
            VSplitView {
                VStack {
                    EditorPaneView()
                    ActionBarView()
                }
                .padding()
                .frame(minWidth: 500, maxWidth: .infinity, minHeight: 310, maxHeight: .infinity)
                .layoutPriority(1)
                
                if state.isShowingOutput {
                    OutputPaneView()
                        .padding()
                        .frame(minWidth: 500, maxWidth: .infinity, minHeight: 115, maxHeight: .infinity)
                }
            }
            .layoutPriority(1)
            
            if state.isShowingInspector {
                InspectorPaneView(state: state)
                    .frame(minWidth: 235, maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxHeight: .infinity)
        .toolbar {
            ToolbarContentView()
        }
    }
}

#Preview {
    MainDocumentView()
        .environmentObject(settings)
        .environment(previewState)
}
