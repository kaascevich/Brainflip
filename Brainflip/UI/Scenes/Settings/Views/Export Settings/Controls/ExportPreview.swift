import SwiftUI
import Introspect

struct ExportPreview: View {
    @EnvironmentObject private var settings: AppSettings
    
    private let sampleCode = try! BrainflipToC.convertToC(Program(string: ",[>+#<-.]"))
    
    var body: some View {
        TextEditor(text: .constant(sampleCode))
            .font(settings.monospaced ? .system(size: settings.textSize).monospaced() : .system(size: settings.textSize))
            .introspect(.textEditor, on: .macOS(.v14)) {
                $0.isEditable = false
            }
    }
}

struct ExportPreview_Previews: PreviewProvider {
    static var previews: some View {
        ExportPreview()
            .environmentObject(settings)
    }
}
