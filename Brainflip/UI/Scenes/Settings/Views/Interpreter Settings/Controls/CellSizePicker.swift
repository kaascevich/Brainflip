import SwiftUI

struct CellSizePicker: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Picker("Cell size", selection: settings.$cellSize) {
            ForEach(CellSize.allCases, id: \.self) { size in
                switch size {
                    case .eightBit:     Text("8-bit")
                    case .sixteenBit:   Text("16-bit")
                    case .thirtyTwoBit: Text("32-bit")
                }
            }
        }
        .pickerStyle(.segmented)
        .help("""
              Controls the maximum value a cell can hold. Use this setting with caution.
               - 8-bit: Maximum value is 255
               - 16-bit: Maximum value is 65,535
               - 32-bit: Maximum value is 4,294,967,295
              """)
    }
}

private struct CellSizePicker_Previews: PreviewProvider {
    static var previews: some View {
        CellSizePicker()
            .environmentObject(settings)
    }
}
