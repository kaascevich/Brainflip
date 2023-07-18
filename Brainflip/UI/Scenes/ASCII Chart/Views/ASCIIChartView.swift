import SwiftUI

struct ASCIIChartView: View {
    var body: some View {
        Table(Array<Int>(asciiValues.indices)) {
            TableColumn("Number") {
                Text("\($0)")
            }
            .width(50)
            TableColumn("ASCII Equivalent") {
                Text(asciiValues[$0])
            }
            .width(100)
        }
    }
}

#Preview {
    ASCIIChartView()
        .environmentObject(settings)
}
