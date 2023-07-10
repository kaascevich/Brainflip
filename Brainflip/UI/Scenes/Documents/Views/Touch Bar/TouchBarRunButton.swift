import SwiftUI

struct TouchBarRunButton: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some View {
        Button {
            state.run()
        } label: {
            Image(systemName: "play.fill")
                .imageScale(.large)
                .padding(19)
        }
        .disabled(state.disableRunButton)
    }
}
