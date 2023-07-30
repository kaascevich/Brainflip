import Foundation
import AppKit

enum SystemSounds: String {
    case basso
    case blow
    case bottle
    case frog
    case funk
    case glass
    case hero
    case morse
    case ping
    case pop
    case purr
    case sosumi
    case submarine
    case tink
    
    static let start   = purr
    static let success = glass
    static let step    = pop
    static let fail    = sosumi
    
    func play() {
        let sound = NSSound(named: self.rawValue.capitalized)
        sound?.stop()
        sound?.play()
    }
}
