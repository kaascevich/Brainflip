import SwiftUI

struct ArrayView: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some View {
        List {
            ForEach(state.interpreter.cellArray.indices, id: \.self) { index in
                HStack {
                    Text("\(index).")
                        .foregroundColor(state.interpreter.pointer == index ? .green : .primary)
                        .accessibilityLabel("Cell \(index) index")
                        .accessibilityValue(String(index))
                    Spacer()
                    Text(String(state.interpreter.cellArray[index]))
                        .bold()
                        .accessibilityLabel("Cell \(index) value")
                        .accessibilityValue(String(state.interpreter.cellArray[index]))
                }
            }
        }
    }
}

#Preview {
    ArrayView(state: previewState)
        .environmentObject(settings)
}
