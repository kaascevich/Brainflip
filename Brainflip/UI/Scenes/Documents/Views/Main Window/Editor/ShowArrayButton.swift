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
                }
                .width(45)
                
                TableColumn("Value") {
                    Text(String(state.interpreter.cellArray[$0]))
                        .bold()
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

private struct ShowArrayButton_Previews: PreviewProvider {
    @State private static var document = ProgramDocument(",[>+<-.]")
    
    static var previews: some View {
        ShowArrayButton(state: ProgramState(document: document, filename: "File.bf"))
            .environmentObject(settings)
    }
}
