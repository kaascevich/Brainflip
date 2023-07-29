import SwiftUI

struct ProgramProgressView: View {
    @EnvironmentObject private var settings: AppSettings
    @Environment(ProgramState.self) private var state: ProgramState
    
    var actualMax: Double {
        Double(state.document.program.count - 1)
    }
    var max: Double {
        if actualMax == 0 { 1 }
        else { actualMax }
    }
    var current: Double? {
        if state.isRunningProgram { nil }
        else if max <= 0 { 0 }
        else { Double(state.interpreter.currentInstructionIndex) }
    }
    
    var body: some View {
        HStack {
            Text("0").accessibilityHidden(true)
            
            if state.isRunningProgram {
                ProgressView().progressViewStyle(.linear)
            } else {
                ProgressView(value: current, total: max)
            }
            
            Text("\(Int(actualMax))").accessibilityHidden(true)
        }
    }
}

#Preview {
    ProgramProgressView()
        .environmentObject(settings)
        .environment(previewState)
}
