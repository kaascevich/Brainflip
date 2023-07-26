import SwiftUI

struct ActionBarView: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some View {
        VStack {
            InputField(state: state)
            if settings.showProgress {
                ProgramProgressView(state: state)
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

//#Preview {
//    ActionBarView(state: previewState)
//        .environmentObject(settings)
//}
