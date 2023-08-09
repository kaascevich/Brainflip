// MeasureAsync.swift
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

extension XCTestCase {
    /// Records the selected metrics for an asynchronous block of code.
    ///
    /// - Parameters:
    ///   - metrics: An array of metrics to measure, like CPU, memory, or elapsed time.
    ///   - block: A block whose performance is measured.
    ///   - seconds: The time, in seconds, the test allows for the measurement to
    ///     complete. The default timeout allows the test to run until it reaches its
    ///     execution time allowance.
    ///   - file: The file where the failure occurs. The default is the filename
    ///     of the test case where you call this function.
    ///   - line: The line number where the failure occurs. The default is the
    ///     line number where you call this function.
    func measureAsync(
        metrics: [XCTMetric] = defaultMetrics,
        for block: @escaping () async throws -> Void,
        timeout seconds: TimeInterval = .infinity,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        measure(metrics: metrics) {
            let expectation = expectation(description: "finished")
            
            Task { @MainActor in
                defer {
                    expectation.fulfill()
                }
                
                do {
                    try await block()
                } catch {
                    XCTFail(error.localizedDescription, file: file, line: line)
                }
            }
            
            wait(for: [expectation], timeout: seconds)
        }
    }
}
