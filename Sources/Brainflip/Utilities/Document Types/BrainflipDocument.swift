// BrainflipDocument.swift
// Copyright © 2023 Kaleb A. Ascevich
//
// This app is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation, either version 3 of the License, or (at your
// option) any later version.
//
// This app is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License
// for more details.
//
// You should have received a copy of the GNU General Public License along
// with this app. If not, see https://www.gnu.org/licenses/.

import Observation
import SwiftUI
import UniformTypeIdentifiers

@Observable final class BrainflipDocument: FileDocument, Identifiable {
    let id = UUID()
    
    var filename = "Untitled"
        
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
    
    func snapshot(contentType _: UTType) throws -> String { contents }
    
    func fileWrapper(configuration _: WriteConfiguration) throws -> FileWrapper {
        let data = contents.data(using: .ascii) ?? "\0".data(using: .ascii)!
        let fileWrapper = FileWrapper(regularFileWithContents: data)
        return fileWrapper
    }
}

extension UTType {
    static let brainflipSource = UTType(exportedAs: "com.kascevich.brainflip-source")
}
