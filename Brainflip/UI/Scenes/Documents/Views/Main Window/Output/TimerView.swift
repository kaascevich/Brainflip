import SwiftUI

struct TimerView: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some View {
        Text(formatTimeElapsed(state.timeElapsed))
            .monospacedDigit()
            .onReceive(state.timer ?? Timer.publish(every: .infinity, on: .main, in: .common).autoconnect()) {
                state.timeElapsed = $0.timeIntervalSince(state.startDate)
            }
    }
    
    func formatTimeElapsed(_ timeElapsed: TimeInterval) -> String {
        let pattern = Duration.TimeFormatStyle.Pattern.hourMinuteSecond(
            padHourToLength: 1,
            fractionalSecondsLength: 2
        )
        let formatStyle = Duration.TimeFormatStyle(pattern: pattern)
        
        let timeDuration = Duration.seconds(timeElapsed)
        return timeDuration.formatted(formatStyle)
    }
}

#Preview {
    TimerView(state: previewState)
        .environmentObject(settings)
}
