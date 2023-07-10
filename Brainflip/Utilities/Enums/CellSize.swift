import Foundation

enum CellSize: Int, CaseIterable, Hashable {
    case eightBit     = 255           // (2^8 ) - 1
    case sixteenBit   = 65_535        // (2^16) - 1
    case thirtyTwoBit = 4_294_967_295 // (2^32) - 1
}
