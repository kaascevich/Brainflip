import SwiftUI

struct ClearMenu: View {
    @EnvironmentObject private var settings: AppSettings
    @Bindable var state: AppState
    
    var body: some View {
        Menu("Clear") {
            ClearInputButton()
            ClearAllButton()
        }
        .confirmationDialog("Are you sure you want to clear everything in the program editor?", isPresented: $state.isClearAlertShowing) {
            Button("Clear", role: .destructive) {
                state.clearAll()
            }
        }
        .fixedSize()
    }
}

#Preview {
    ClearMenu(state: previewState)
        .environmentObject(settings)
}
