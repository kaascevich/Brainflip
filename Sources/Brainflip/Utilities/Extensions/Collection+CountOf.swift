import Foundation

extension Collection where Element: Equatable {
    /// The number of elements in the collection that equal the given element.
    ///
    /// - Parameter element: The element to count.
    ///
    /// - Returns: The number of times `element` appears in the collection.
    func count(of element: Element) -> Int {
        filter { $0 == element }.count
    }
}
