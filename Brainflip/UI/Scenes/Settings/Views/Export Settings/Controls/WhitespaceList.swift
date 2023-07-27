import SwiftUI

struct WhitespaceList: View {
    @EnvironmentObject private var settings: AppSettings
    @State private var isShowingWhitespaceSettings = false
    
    typealias Whitespace = BrainflipToC.Whitespace
        
    var body: some View {
        Button("Whitespace...") {
            isShowingWhitespaceSettings.toggle()
        }
        .sheet(isPresented: $isShowingWhitespaceSettings) {
            Form {
                Section("Show whitespace:") {
                    List(Whitespace.allCases.indices, id: \.self) {
                        Toggle(Whitespace.allCases[$0].rawValue, isOn: Whitespace.$enabledWhitespace[$0])
                    }
                    .padding(5)
                }
            }
            .formStyle(.grouped)
            .frame(width: 390, height: 414)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        isShowingWhitespaceSettings = false
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

#Preview {
    WhitespaceList()
        .environmentObject(settings)
}
