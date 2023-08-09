// CSourceDocument.swift
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

import SwiftUI
import UniformTypeIdentifiers

final class CSourceDocument: FileDocument, Identifiable {
    let id = UUID()
        
    var contents: String
    init?(_ contents: String? = "") {
        guard let contents else {
            return nil
        }
        self.contents = contents
    }
        
    static let readableContentTypes: [UTType] = [.cSource]
    
    convenience init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        self.init(String(data: data, encoding: .utf8) ?? "")!
    }
    
    func snapshot(contentType _: UTType) throws -> String { contents }
    
    func fileWrapper(configuration _: WriteConfiguration) throws -> FileWrapper {
        let data = contents.data(using: .utf8) ?? "\0".data(using: .utf8)!
        return FileWrapper(regularFileWithContents: data)
    }
}
