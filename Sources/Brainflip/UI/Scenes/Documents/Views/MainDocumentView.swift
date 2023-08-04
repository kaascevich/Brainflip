import SwiftUI

struct MainDocumentView: View {
    @EnvironmentObject private var settings: AppSettings
    @Bindable var state: AppState
    
    var body: some View {
        VSplitView {
            VStack {
                EditorPaneView()
                ActionBarView()
            }
            .padding()
            .frame(minHeight: 310)
            .layoutPriority(1)
            
            if state.isShowingOutput {
                OutputPaneView()
                    .padding()
                    .frame(minHeight: 115)
            }
        }
        .frame(minWidth: 500)
        .inspector(isPresented: $state.isShowingInspector) {
            InspectorPaneView(state: state)
        }
        .toolbar {
            ToolbarContentView()
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    MainDocumentView(state: previewState)
        .environmentObject(settings)
        .environment(previewState)
}
