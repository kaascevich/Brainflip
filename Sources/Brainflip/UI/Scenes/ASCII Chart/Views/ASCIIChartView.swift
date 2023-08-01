import SwiftUI

struct ASCIIChartView: View {
    var body: some View {
        List {
            ForEach(asciiValues.indices, id: \.self) { index in
                HStack {
                    Text("\(index).")
                        .accessibilityLabel("Cell \(index) index")
                        .accessibilityValue(String(index))
                    Spacer()
                    Text(String(asciiValues[index]))
                        .bold()
                        .accessibilityLabel("Cell \(index) value")
                        .accessibilityValue(String(asciiValues[index]))
                }
            }
        }
    }
}

#Preview {
    ASCIIChartView()
        .environmentObject(settings)
}
