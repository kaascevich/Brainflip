// TimerView.swift
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

struct TimerView: View {
    @Environment(AppState.self) private var state: AppState
    
    var body: some View {
        Text(formattedTimerString)
            .monospacedDigit()
            .accessibilityLabel("Timer")
            .accessibilityValue(accessibilityTimerString)
            .onReceive(state.timer ?? Timer.publish(
                every: .infinity,
                on: .main,
                in: .common
            ).autoconnect()) { date in
                state.timeElapsed = date.timeIntervalSince(state.startDate)
            }
    }
    
    var formattedTimerString: String {
        let pattern = Duration.TimeFormatStyle.Pattern.hourMinuteSecond(
            padHourToLength: 1,
            fractionalSecondsLength: 3
        )
        let formatStyle = Duration.TimeFormatStyle(pattern: pattern)
        
        return Duration.seconds(state.timeElapsed).formatted(formatStyle)
    }
    
    var accessibilityTimerString: String {
        let formatStyle = Duration.UnitsFormatStyle(
            allowedUnits: [.hours, .minutes, .seconds, .milliseconds],
            width: .wide
        )
        
        return Duration.seconds(state.timeElapsed).formatted(formatStyle)
    }
}

#Preview {
    TimerView()
        .environment(previewState)
}
