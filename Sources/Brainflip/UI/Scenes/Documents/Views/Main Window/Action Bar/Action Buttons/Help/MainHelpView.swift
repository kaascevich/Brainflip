import SwiftUI

struct MainHelpView: View {
    @Environment(\.openWindow) private var openWindow
    @Environment(\.openURL) private var openURL
    
    @EnvironmentObject private var settings: AppSettings
    @Bindable var state: AppState
        
    static let helpContent: AttributedString = {
        let fileURL = Bundle.main.url(
            forResource: "MainHelp",
            withExtension: "rtf"
        )!
        
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.rtf]
        
        let string = try! NSAttributedString(
            url: fileURL,
            options: options,
            documentAttributes: nil
        )
        return AttributedString(string)
    }()
    
    
    var body: some View {
        HelpLink {
            state.showingMainHelp.toggle()
        }
        .sheet(isPresented: $state.showingMainHelp) {
            NavigationStack {
                ScrollView {
                    Text(MainHelpView.helpContent)
                        .padding()
                        .textSelection(.enabled)
                }
                .frame(width: 650, height: 400)
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
                        Button("Learn More") {
                            let url = URL(string: "http://brainfuck.org/")!
                            openURL(url)
                        }
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
