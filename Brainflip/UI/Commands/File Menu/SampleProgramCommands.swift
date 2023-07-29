import SwiftUI
import Foundation

struct SampleProgramCommands: Commands {
    @Environment(\.openDocument) var openDocument
    @FocusedValue(\.programState) private var state
    
    var samplePrograms: [URL] {
        Bundle.main.urls(forResourcesWithExtension: "bf", subdirectory: "Sample Programs")!.sorted { $0.absoluteString < $1.absoluteString }
    }
    
    var body: some Commands {
        CommandGroup(after: .saveItem) {
            Divider()
            Menu("Sample Programs") {
                ForEach(samplePrograms, id: \.hashValue) { sampleProgram in
                    Button(sampleProgram.lastPathComponent.dropLast(sampleProgram.pathExtension.count + 1)) {
                        Task { try await openDocument(at: sampleProgram) }
                    }
                    .accessibilityIdentifier("openSampleProgram:")
                }
            }
            .accessibilityIdentifier("samplePrograms:")
        }
    }
}
