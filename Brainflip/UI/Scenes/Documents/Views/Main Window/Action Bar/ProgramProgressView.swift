import SwiftUI

struct ProgramProgressView: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var actualMax: Double {
        return Double(state.document.program.count - 1)
    }
    var max: Double {
        if actualMax == 0 {
            return 1
        } else {
            return actualMax
        }
    }
    var current: Double? {
        if state.isRunningProgram {
            return nil
        } else if max <= 0 {
            return 0
        } else {
            return Double(state.interpreter.currentInstructionIndex)
        }
    }
    
    var body: some View {
        HStack {
            Text("0")
            if state.isRunningProgram {
                ProgressView()
                    .progressViewStyle(.linear)
            } else {
                ProgressView(value: current, total: max)
            }
            Text("\(Int(actualMax))")
        }
    }
}

#Preview {
    ProgramProgressView(state: previewState)
        .environmentObject(settings)
}
