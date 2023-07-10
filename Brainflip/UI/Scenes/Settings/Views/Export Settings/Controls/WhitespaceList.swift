import SwiftUI

struct WhitespaceList: View {
    @EnvironmentObject private var settings: AppSettings
    @State private var isShowingWhitespaceSettings = false
    @Binding(get: {
        Whitespace.allCases.map { $0.enabled }
    }, set: {
        let oldSettings = Whitespace.allCases.map { $0.enabled }
        for settingIndex in 0...(Whitespace.allCases.count - 1) {
            if oldSettings[settingIndex] != $0[settingIndex] {
                Whitespace.allCases[settingIndex].setEnabled($0[settingIndex])
                break
            }
        }
    }) var enabledWhitespace: [Bool]
    
    var body: some View {
        Button("Whitespace...") {
            isShowingWhitespaceSettings.toggle()
        }
        .sheet(isPresented: $isShowingWhitespaceSettings) {
            Form {
                Section("Show whitespace:") {
                    List {
                        ForEach(0...(Whitespace.allCases.count - 1), id: \.self) {
                            Toggle(Whitespace.allCases[$0].rawValue, isOn: $enabledWhitespace[$0])
                        }
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

struct WhitespaceList_Previews: PreviewProvider {
    static var previews: some View {
        WhitespaceList()
            .environmentObject(AppSettings())
    }
}
