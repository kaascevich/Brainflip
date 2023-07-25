import XCTest

/// Asserts that an asynchronous expression throws an error.
///
/// - Parameters:
///   - expression: An asynchronous expression that can throw an error.
///   - message: An optional description of a failure.
///   - file: The file where the failure occurs. The default is the filename
///     of the test case where you call this function.
///   - line: The line number where the failure occurs. The default is the
///     line number where you call this function.
///   - errorHandler: An optional handler for errors that `expression` throws.
func assertAsyncThrowsError<T>(
    _ expression: @autoclosure () async throws -> T,
    _ message: @autoclosure () -> String = "Asynchronous call did not throw an error.",
    file: StaticString = #filePath,
    line: UInt = #line,
    _ errorHandler: (_ error: Error) -> Void = { _ in }
) async {
    do {
        _ = try await expression()
        XCTFail(message(), file: file, line: line)
    } catch {
        errorHandler(error)
    }
}
