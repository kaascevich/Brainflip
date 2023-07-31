import SwiftUI

struct ShowArrayButton: View {
    @EnvironmentObject private var settings: AppSettings
    @Bindable var state: AppState
    
    var body: some View {
        Button("Show Array") {
            state.showingArray.toggle()
        }
        .disabled(state.disableResetButton)
        .popover(isPresented: $state.showingArray) {
            ArrayView()
                .frame(width: 200)
        }
    }
}

#Preview {
    ShowArrayButton(state: previewState)
        .environmentObject(settings)
}
