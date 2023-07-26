import SwiftUI

struct PointerNameField: View {
    @EnvironmentObject private var settings: AppSettings
        
    var body: some View {
        TextField("Pointer name", text: settings.$pointerName)
            .onChange(of: settings.pointerName) { oldName, newName in
                if newName.wholeMatch(of: BrainflipToC.identifierRegex) == nil {
                    settings.pointerName = oldName
                }
            }
    }
}

//#Preview {
//    PointerNameField()
//        .environmentObject(settings)
//}
