import Foundation

extension Array {
    func split(into chunks: Int) -> [[Element]] {
        let size = count / chunks
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
