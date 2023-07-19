import Foundation
import AudioToolbox
import os.log

struct SoundEffect: Hashable {
    static private let logger = Logger(subsystem: bundleID, category: "Sound")
    
    let id: SystemSoundID
    let name: String
    
    init(id: SystemSoundID, name: String) {
        self.id = id
        self.name = name
    }
    
    func play() {
        Self.logger.log("Playing sound \"\(name)\"")
        AudioServicesPlaySystemSoundWithCompletion(id, nil)
    }
}

extension SoundEffect {
    init?(systemName: String) {
        let namesMatch = { (soundEffect: SoundEffect) in
            // Sound effects' names are capitalized, so we need to alter our raw value accordingly
            soundEffect.name == systemName.capitalized
        }
        if let soundEffect = Self.systemSoundEffects.first(where: namesMatch) {
            self = soundEffect
        } else { return nil }
    }
    
    static let systemSoundEffects: [SoundEffect] = {
        guard let systemSoundFiles = getSystemSoundFileEnumerator() else { return [] }
        return systemSoundFiles.compactMap { item in
            guard let url = item as? URL,
                  let name = url.deletingPathExtension().pathComponents.last
            else { return nil }
            
            var soundID: SystemSoundID = 0
            AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
            guard soundID > 0 else { return nil }
            
            return SoundEffect(id: soundID, name: name)
        }.sorted { $0.name.compare($1.name) == .orderedAscending }
    }()
    
    static private func getSystemSoundFileEnumerator() -> FileManager.DirectoryEnumerator? {
        let libraryDirectories = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .systemDomainMask, true)
        guard let libraryDirectory = libraryDirectories.first,
              let soundsDirectory = NSURL(string: libraryDirectory)?.appendingPathComponent("Sounds"),
              let soundFileEnumerator = FileManager.default.enumerator(at: soundsDirectory, includingPropertiesForKeys: nil)
        else { return nil }
        return soundFileEnumerator
    }
}

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
    
    func play() {
        let soundEffect = SoundEffect(systemName: self.rawValue)
        soundEffect?.play()
    }
    
    static let start   = purr
    static let success = glass
    static let step    = pop
    static let fail    = sosumi
}

