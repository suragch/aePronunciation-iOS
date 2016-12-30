import Foundation
import AudioToolbox

class Player {
    
    fileprivate let audioFolder = "raw"
    
    func playSoundFromFile(_ file: String) {
        var soundURL: URL?
        var soundID: SystemSoundID = 0
        let filePath = Bundle.main.path(forResource: "\(audioFolder)/\(file)", ofType: "mp3")
        soundURL = URL(fileURLWithPath: filePath!)
        if let url = soundURL {
            AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
            AudioServicesPlaySystemSound(soundID)
        }
    }
}
