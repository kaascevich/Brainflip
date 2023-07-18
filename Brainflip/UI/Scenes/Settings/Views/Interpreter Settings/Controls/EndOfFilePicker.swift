import SwiftUI

struct EndOfFilePicker: View {
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        Picker("When there’s no input left:", selection: settings.$endOfInput) {
            ForEach(Interpreter.EndOfInput.allCases, id: \.self) {
                Text(endOfInputSettingName($0))
            }
        }
        .help("Controls the action the interpreter takes when it encounters an input command, but there are no input characters remaining.")
    }
    
    func endOfInputSettingName(_ endOfInput: Interpreter.EndOfInput) -> String {
        switch endOfInput {
        case .noChange:
            return "Leave the current cell unchanged"
        case .setToZero:
            return "Set the current cell to zero"
        case .setToMax:
            return "Set the current cell to \((settings.cellSize.rawValue).formatted())"
        }
    }
}

#Preview {
    EndOfFilePicker()
}
