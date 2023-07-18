import SwiftUI

struct ASCIIChartView: View {
    @EnvironmentObject private var settings: AppSettings
    
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

private struct ASCIIChartView_Previews: PreviewProvider {
    static var previews: some View {
        ASCIIChartView()
            .environmentObject(settings)
    }
}
