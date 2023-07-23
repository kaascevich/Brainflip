import SwiftUI

struct TimerView: View {
    @EnvironmentObject private var settings: AppSettings
    @ObservedObject var state: ProgramState
    
    var body: some View {
        Text(formatTimeElapsed(state.timeElapsed, startDate: state.startDate))
            .monospacedDigit()
            .onReceive(state.timer ?? Timer.publish(every: .infinity, on: .main, in: .common).autoconnect()) {
                state.timeElapsed = $0.timeIntervalSince(state.startDate)
            }
    }
    
    func formatTimeElapsed(_ timeElapsed: TimeInterval, startDate: Date) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        
        let endDate = Date(timeInterval: timeElapsed, since: startDate)
        
        let milliseconds = Int(timeElapsed * 100).quotientAndRemainder(dividingBy: 100).remainder
        let zero = milliseconds < 10 ? "0" : ""
        
        return "\(formatter.string(from: startDate, to: endDate)!).\(zero)\(milliseconds)"
    }
}

#Preview {
    TimerView(state: previewState)
        .environmentObject(settings)
}
