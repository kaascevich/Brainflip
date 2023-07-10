import Foundation

func userFriendlyStringSize(_ string: String) -> String {
    var output = ""
    if string.count < 1_000 {
        output += "\(string.count) byte"
        output += (string.count == 1) ? "" : "s"
    } else {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        
        let sizeInKB = Double(string.count) / 1_000
        output += formatter.string(from: sizeInKB as NSNumber)!
        output += " kilobytes"
    }
    return output
}
