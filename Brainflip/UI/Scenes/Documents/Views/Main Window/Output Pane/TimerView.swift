import SwiftUI

struct TimerView: View {
    @EnvironmentObject private var settings: AppSettings
    @Environment(ProgramState.self) var state: ProgramState
    
    var body: some View {
        Text(formatTimeElapsed(state.timeElapsed))
            .monospacedDigit()
            .onReceive(state.timer ?? Timer.publish(every: .infinity, on: .main, in: .common).autoconnect()) {
                state.timeElapsed = $0.timeIntervalSince(state.startDate)
            }
            .accessibilityLabel("Timer")
            .accessibilityValue(accessibilityTimerString(state.timeElapsed))
    }
    
    func formatTimeElapsed(_ timeElapsed: TimeInterval) -> String {
        let pattern = Duration.TimeFormatStyle.Pattern.hourMinuteSecond(
            padHourToLength: 1,
            fractionalSecondsLength: 3
        )
        let formatStyle = Duration.TimeFormatStyle(pattern: pattern)
        
        let timeDuration = Duration.seconds(timeElapsed)
        return timeDuration.formatted(formatStyle)
    }
    
    func accessibilityTimerString(_ timeInterval: TimeInterval) -> String {
        let formatStyle = Duration.UnitsFormatStyle(
            allowedUnits: [.hours, .minutes, .seconds, .milliseconds],
            width: .wide
        )
        
        return Duration.seconds(timeInterval).formatted(formatStyle)
    }
}

#Preview {
    TimerView()
        .environmentObject(settings)
        .environment(previewState)
}
