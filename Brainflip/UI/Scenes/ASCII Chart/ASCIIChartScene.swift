import SwiftUI

struct ASCIIChartScene: Scene {
    var body: some Scene {
        Window("ASCII Chart", id: "ascii") {
            ASCIIChartView()
                .frame(width: 200)
                .frame(minHeight: 150)
                .environmentObject(settings)
        }
        .windowResizability(.contentSize)
        .keyboardShortcut("1")
    }
}
