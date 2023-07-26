import SwiftUI

struct CellSizePicker: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Picker("Cell size", selection: settings.$cellSize) {
            ForEach(CellSize.allCases, id: \.self) { size in
                Text(size.localizedStringResource)
            }
        }
        .pickerStyle(.segmented)
        .help("""
              Controls the maximum value a cell can hold. Use this setting with caution.
               - 1-bit: Maximum value is 1
               - 2-bit: Maximum value is 3
               - 4-bit: Maximum value is 15
               - 8-bit: Maximum value is 255 (recommended, default)
               - 16-bit: Maximum value is 65,535
               - 32-bit: Maximum value is 4,294,967,295
              """)
    }
}

#Preview {
    CellSizePicker()
        .environmentObject(settings)
}
