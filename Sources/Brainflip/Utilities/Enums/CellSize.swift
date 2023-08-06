// CellSize.swift
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

import AppIntents
import Foundation

/// The possible sizes for a cell.
enum CellSize: Int, CaseIterable, Hashable, AppEnum {
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Cell Size"
    static let caseDisplayRepresentations: [CellSize: DisplayRepresentation] = [
        .oneBit:       "1-Bit",
        .twoBit:       "2-Bit",
        .fourBit:      "4-Bit",
        .eightBit:     "8-Bit",
        .sixteenBit:   "16-Bit",
        .thirtyTwoBit: "32-Bit"
    ]
    
    /// Represents a cell size of 2¹-1 = 1.
    case oneBit = 1
    
    /// Represents a cell size of 2²-1 = 3.
    case twoBit = 3
    
    /// Represents a cell size of 2⁴-1 = 15.
    case fourBit = 15
    
    /// Represents a cell size of 2⁸-1 = 255.
    case eightBit = 255
    
    /// Represents a cell size of 2¹⁶-1 = 65,535.
    case sixteenBit = 65_535
    
    /// Represents a cell size of 2³²-1 = 4,294,967,295.
    case thirtyTwoBit = 4_294_967_295
}
