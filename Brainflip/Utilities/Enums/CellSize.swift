import Foundation
import AppIntents

/// The possible sizes for a cell.
enum CellSize: Int, CaseIterable, Hashable, AppEnum {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Cell Size"
    static var caseDisplayRepresentations: [CellSize: DisplayRepresentation] = [
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

