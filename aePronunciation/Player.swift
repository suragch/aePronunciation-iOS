import AVFoundation

class Player {
    
    private let audioPlayer = AVPlayer()
    private let audioFolder = "raw"
    
    func playSoundFrom(file: String) {
        // get the path string for the video from assets
        let audioString:String? = Bundle.main.path(forResource: "\(audioFolder)/\(file)", ofType: "mp3")
        guard let unwrappedAudioPath = audioString else {return}
        
        // convert the path string to a url
        let audioUrl = URL(fileURLWithPath: unwrappedAudioPath)
        
        let asset = AVAsset(url: audioUrl)
        let playerItem = AVPlayerItem(asset: asset)
        audioPlayer.replaceCurrentItem(with: playerItem)
        audioPlayer.play()
    }
    
    
//    func playSoundFromFile(_ file: String) {
//        var soundURL: URL?
//        var soundID: SystemSoundID = 0
//        let filePath = Bundle.main.path(forResource: "\(audioFolder)/\(file)", ofType: "mp3")
//        soundURL = URL(fileURLWithPath: filePath!)
//        if let url = soundURL {
//            AudioServicesCreateSystemSoundID(url as CFURL, &soundID)
//            AudioServicesPlaySystemSound(soundID)
//        }
//    }
}
