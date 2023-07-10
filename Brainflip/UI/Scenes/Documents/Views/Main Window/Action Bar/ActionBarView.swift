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

private struct ActionBarView_Previews: PreviewProvider {
    @State private static var document = ProgramDocument(",[>+<-.]")
    
    static var previews: some View {
        ActionBarView(state: ProgramState(document: document))
            .environmentObject(AppSettings())
    }
}
