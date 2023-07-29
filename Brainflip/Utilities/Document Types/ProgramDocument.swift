import SwiftUI
import UniformTypeIdentifiers
import Observation

@Observable final class ProgramDocument: FileDocument, Identifiable {
    let id = UUID()
    
    var filename: String = "Untitled"
        
    var contents: String
    init(_ contents: String = "") {
        self.contents = contents
    }
    
    var program: Program { Program(string: contents) }
        
    static let readableContentTypes: [UTType] = [.brainflipSource]
    
    convenience init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let contents = String(data: data, encoding: .utf8),
              let filename = configuration.file.preferredFilename
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        self.init(contents)
        self.filename = filename
    }
    
    func snapshot(contentType: UTType) throws -> String { contents }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = contents.data(using: .ascii) ?? "\0".data(using: .ascii)!
        let fileWrapper = FileWrapper(regularFileWithContents: data)
        return fileWrapper
    }
}

extension UTType {
    static let brainflipSource: UTType = UTType(exportedAs: "com.kascevich.brainflip-source")
}
