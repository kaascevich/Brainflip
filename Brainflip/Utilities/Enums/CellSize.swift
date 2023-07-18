import Foundation
import AppIntents

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
    
    case oneBit       = 1             // (2^1 ) - 1
    case twoBit       = 3             // (2^2 ) - 1
    case fourBit      = 15            // (2^4 ) - 1
    case eightBit     = 255           // (2^8 ) - 1
    case sixteenBit   = 65_535        // (2^16) - 1
    case thirtyTwoBit = 4_294_967_295 // (2^32) - 1
}
