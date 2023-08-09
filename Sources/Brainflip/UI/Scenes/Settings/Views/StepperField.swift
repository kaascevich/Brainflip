// StepperField.swift
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

struct StepperField: View {
    @Binding var value: Int
    var range: ClosedRange<Int>
    var step: Int
    var label: String
    
    init(
        value: Binding<Int>,
        in range: ClosedRange<Int>,
        step: Int = 1,
        label: String = ""
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.label = label
        formatter = {
            let formatter = NumberFormatter()
            formatter.allowsFloats = false
            formatter.minimum = range.lowerBound as NSNumber
            formatter.maximum = range.upperBound as NSNumber
            return formatter
        }()
    }
    
    init(
        value: Binding<Double>,
        in range: ClosedRange<Int>,
        step: Int = 1,
        label: String = ""
    ) {
        self.init(
            value: value.int,
            in: range,
            step: step,
            label: label
        )
    }
    
    private var formatter: NumberFormatter
    
    var body: some View {
        Stepper(value: $value, in: range, step: step) {
            HStack {
                Text(label)
                Spacer()
                TextField("", value: $value, formatter: formatter)
                    .textFieldStyle(.squareBorder)
                    .fixedSize()
                    .multilineTextAlignment(.trailing)
                    .monospacedDigit()
            }
        }
        .accessibilityValue(String(value))
    }
}

fileprivate extension Double {
    var int: Int {
        get {
            Int(self)
        }
        set {
            self = Double(newValue)
        }
    }
}

#Preview {
    StepperField(value: .constant(5), in: 1...10, step: 2, label: "Testing")
}
