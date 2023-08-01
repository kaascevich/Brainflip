import SwiftUI

struct ActionBarView: View {
    @EnvironmentObject private var settings: AppSettings
    @Environment(AppState.self) private var state: AppState
    
    var body: some View {
        VStack {
            InputField(state: state)
            if settings.showProgress {
                ProgramProgressView()
            }
            HStack {
                MainHelpView(state: state)
                Spacer()
                ActionButtons(state: state)
                Spacer()
            }
        }
    }
}

#Preview {
    ActionBarView()
        .environmentObject(settings)
        .environment(previewState)
}
