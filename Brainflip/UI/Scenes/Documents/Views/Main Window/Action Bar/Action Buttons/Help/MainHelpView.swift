import SwiftUI

struct MainHelpView: View {
    @Environment(\.openWindow) var openWindow
    
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
        
    let helpContent: NSAttributedString? = {
        guard let fileURL = Bundle.main.url(forResource: "MainHelp", withExtension: "rtf") else {
            return nil
        }
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf]
        guard let string = try? NSAttributedString(url: fileURL, options: options, documentAttributes: nil) else {
            return nil
        }
        return string
    }()
    
    
    var body: some View {
        HelpLink {
            state.showingMainHelp.toggle()
        }
        .sheet(isPresented: $state.showingMainHelp) {
            NavigationStack {
                ScrollView {
                    Text(AttributedString(helpContent ?? NSAttributedString("")))
                        .padding()
                        .textSelection(.enabled)
                }
                .frame(width: 650)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button("Done") {
                            state.showingMainHelp = false
                        }
                    }
                    
                    ToolbarItemGroup(placement: .automatic) {
                        Button("Show ASCII Chart") {
                            openWindow(id: "ascii")
                        }
                        Link("Learn More", destination: URL(string: "http://brainfuck.org/")!)
                            .buttonStyle(.bordered)
                    }
                }
                .navigationTitle("Brainflip Help")
            }
        }
    }
}

#Preview {
    MainHelpView(state: previewState)
        .environmentObject(settings)
}
