import SwiftUI

struct ShowArrayButton: View {
    @EnvironmentObject private var settings:     AppSettings
    @ObservedObject            var state:        ProgramState
    
    var body: some View {
        Button("Show Array") {
            state.showingArray.toggle()
        }
        .disabled(state.disableResetButton)
        .popover(isPresented: $state.showingArray) {
            Table(state.interpreter.cellArray.indices) {
                TableColumn("Index") {
                    Text(String($0))
                        .foregroundColor(state.interpreter.pointer == $0 ? .green : .primary)
                        .accessibilityLabel("Cell \($0) index")
                        .accessibilityValue(String($0))
                }
                .width(45)
                
                TableColumn("Value") {
                    Text(String(state.interpreter.cellArray[$0]))
                        .bold()
                        .accessibilityLabel("Cell \($0) value")
                        .accessibilityValue(String(state.interpreter.cellArray[$0]))
                }
                .width(155)
            }
            .frame(width: 200, height: 300)
        }
    }
}

extension Int: Identifiable {
    public var id: Int {
        self
    }
}

#Preview {
    ShowArrayButton(state: previewState)
        .environmentObject(settings)
}
