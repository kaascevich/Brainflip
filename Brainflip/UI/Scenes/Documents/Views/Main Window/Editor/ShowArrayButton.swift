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
                        .accessibilityIdentifier("Cell \($0) index")
                }
                .width(45)
                
                TableColumn("Value") {
                    Text(String(state.interpreter.cellArray[$0]))
                        .bold()
                        .accessibilityIdentifier("Cell \($0) value")
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

//#Preview {
//    ShowArrayButton(state: previewState)
//        .environmentObject(settings)
//}
