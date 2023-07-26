import SwiftUI

struct ArrayNameField: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        TextField("Array name", text: settings.$arrayName)
            .onChange(of: settings.arrayName) { oldName, newName in
                if newName.wholeMatch(of: BrainflipToC.identifierRegex) == nil {
                    settings.arrayName = oldName
                }
            }
    }
}

//#Preview {
//    ArrayNameField()
//        .environmentObject(settings)
//}
