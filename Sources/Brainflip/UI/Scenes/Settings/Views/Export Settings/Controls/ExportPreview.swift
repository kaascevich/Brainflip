import SwiftUI
import SwiftUIIntrospect

struct ExportPreview: View {
    @EnvironmentObject private var settings: AppSettings
    
    private let sampleCode = try! BrainflipToC.convertToC(Program(string: ",[>+#<-.]"))
    
    var body: some View {
        TextEditor(text: .constant(sampleCode))
            .font(.system(
                size: settings.textSize,
                design: settings.monospaced ? .monospaced: .default
            ))
            .introspect(.textEditor, on: .macOS(.v14)) {
                $0.isEditable = false
            }
    }
}

#Preview {
    ExportPreview()
        .environmentObject(settings)
}
