import SwiftUI
import UniformTypeIdentifiers

final class CSourceDocument: FileDocument {
    var id = UUID()
        
    var contents: String
    init(_ contents: String = "") {
        self.contents = contents
    }
        
    static var readableContentTypes: [UTType] = [.cSource]
    
    convenience init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.init(String(data: data, encoding: .utf8) ?? "")
    }
    
    func snapshot(contentType: UTType) throws -> String {
        contents
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = contents.data(using: .utf8) ?? "\0".data(using: .utf8)!
        return FileWrapper(regularFileWithContents: data)
    }
}
