import SwiftUI

struct ShowArrayButton: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some View {
        Button("Show Array") {
            state.showingArray.toggle()
        }
        .disabled(state.disableResetButton)
        .popover(isPresented: $state.showingArray) {
            ArrayView(state: state)
                .frame(width: 200, height: 300)
        }
    }
}

#Preview {
    ShowArrayButton(state: previewState)
        .environmentObject(settings)
}
