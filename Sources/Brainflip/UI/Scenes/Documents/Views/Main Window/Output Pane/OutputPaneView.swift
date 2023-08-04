import SwiftUI
import SwiftUIIntrospect

struct OutputPaneView: View {
    @EnvironmentObject private var settings: AppSettings
    @Environment(AppState.self) private var state: AppState
    
    var body: some View {
        VStack {
            HStack {
                Text("Output")
                    .accessibilityHidden(true)
                Spacer()
                if settings.showTimer {
                    TimerView()
                }
                CopyButton { state.output }
                    .buttonStyle(.borderless)
                    .labelStyle(.iconOnly)
            }
            OutputView()
        }
    }
}

#Preview {
    OutputPaneView()
        .environmentObject(settings)
        .environment(previewState)
}
