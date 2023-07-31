import SwiftUI
import AppKit

struct ExportToCCommand: View {
    @FocusedValue(\.appState) private var state
    
    var body: some View {
        Button("Export to C Source…") {
            if settings.exportToCAlertHidden {
                state?.exportToC()
            } else {
                state?.isInformingAboutCExport.toggle()
            }
        }
        .accessibilityIdentifier("exportDocumentToCSource:")
    }
}
