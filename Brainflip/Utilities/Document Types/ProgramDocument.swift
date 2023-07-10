import SwiftUI
import UniformTypeIdentifiers

final class ProgramDocument: FileDocument, Identifiable, ObservableObject {
    var id = UUID()
        
    var contents: String
    init(_ contents: String = "") {
        self.contents = contents
    }
    
    var program: Program {
        return Program(string: contents)
    }
        
    static var readableContentTypes: [UTType] = [.brainflipSource]
    
    convenience init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.init(String(data: data, encoding: .ascii) ?? "")
    }
    
    func snapshot(contentType: UTType) throws -> String {
        return contents
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = contents.data(using: .ascii) ?? "\0".data(using: .ascii)!
        let fileWrapper = FileWrapper(regularFileWithContents: data)
        return fileWrapper
    }
}

extension UTType {
    static var brainflipSource: UTType {
        UTType(exportedAs: "com.kascevich.brainflip-source")
    }
}
