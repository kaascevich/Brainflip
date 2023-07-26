import SwiftUI

struct ClearMenu: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some View {
        Menu("Clear") {
            ClearInputButton(state: state)
            ClearAllButton(state: state)
        }
        .confirmationDialog("Are you sure you want to clear everything in the program editor?", isPresented: $state.isClearAlertShowing) {
            Button("Clear", role: .destructive) {
                state.clearAll()
            }
        }
        .fixedSize()
    }
}

//#Preview {
//    ClearMenu(state: previewState)
//        .environmentObject(settings)
//}
