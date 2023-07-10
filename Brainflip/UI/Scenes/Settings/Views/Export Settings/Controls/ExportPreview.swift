import SwiftUI

struct ExportPreview: View {
    @EnvironmentObject private var settings: AppSettings
    
    private var sampleCode = BrainflipToC.convertToC(Program(string: ",[>+#<-.]"))
    
    var body: some View {
        TextEditor(text: .constant(sampleCode))
            .font(settings.monospaced ? .system(size: 14).monospaced() : .system(size: 14))
            .introspectTextView {
                $0.isEditable = false
            }
    }
}

struct ExportPreview_Previews: PreviewProvider {
    static var previews: some View {
        ExportPreview()
            .environmentObject(AppSettings())
    }
}
