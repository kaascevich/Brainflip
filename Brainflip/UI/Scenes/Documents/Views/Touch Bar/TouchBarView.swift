import SwiftUI

struct TouchBarView: View {
    @EnvironmentObject private var settings: AppSettings
    @StateObject var state: ProgramState
    
    var body: some View {
        TouchBarRunButton(state: state)
        TouchBarStepButton(state: state)
        Spacer()
        TouchBarResetButton(state: state)
        TouchBarStopButton(state: state)
        Spacer()
    }
}
