import SwiftUI

struct ProgramProgressView: View {
    @EnvironmentObject private var settings: AppSettings
    @Environment(AppState.self) private var state: AppState
    
    var actualMax: Double {
        Double(state.document.program.count - 1)
    }
    var max: Double {
        Swift.max(1, actualMax)
    }
    var current: Double? {
        guard !state.isRunningProgram else { return nil }
        return min(Swift.max(0, Double(state.interpreter.currentInstructionIndex)), max)
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
