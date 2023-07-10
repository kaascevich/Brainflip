import SwiftUI

struct TouchBarResetButton: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some View {
        Button {
            state.reset()
        } label: {
            Image(systemName: "arrow.triangle.2.circlepath.circle")
                .imageScale(.large)
                .padding()
        }
        .disabled(state.disableResetButton)
    }
}
