// AssertAsyncThrowsError.swift
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
func assertAsyncThrowsError<Value>(
    _ expression: @autoclosure () async throws -> Value,
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
