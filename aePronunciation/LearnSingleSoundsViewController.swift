import UIKit
import AVFoundation
import AudioToolbox

class LearnSingleSoundsViewController: UIViewController, KeyboardDelegate {
    
    private var avPlayer: AVPlayer?
    private let player = Player()
    private let defaultIpaToShowFirst = "æ"
    private let singleSound = SingleSound()
    private let learnDoubleSegueId = "learnSingleToLearnDouble"
    
    // MARK: - Outlets
    
    @IBOutlet weak var ipaLabel: UILabel!
    @IBOutlet weak var ipaDescription: UITextView!
    @IBOutlet weak var example1: UIButton!
    @IBOutlet weak var example2: UIButton!
    @IBOutlet weak var example3: UIButton!
    @IBOutlet weak var keyboard: IpaKeyboard!
    @IBOutlet weak var videoView: UIImageView!
    
    // MARK: - Actions
    
    @IBAction func example1(_ sender: UIButton) {
        guard let ipa = ipaLabel.text else {return}
        guard let fileName = SingleSound.getExampleOneFileName(ipa: ipa)
            else {return}
        player.playSoundFrom(file: fileName)
    }
    
    @IBAction func example2(_ sender: UIButton) {
        guard let ipa = ipaLabel.text else {return}
        guard let fileName = SingleSound.getExampleTwoFileName(ipa: ipa)
            else {return}
        player.playSoundFrom(file: fileName)
    }
    
    @IBAction func example3(_ sender: UIButton) {
        guard let ipa = ipaLabel.text else {return}
        guard let fileName = SingleSound.getExampleThreeFileName(ipa: ipa)
            else {return}
        player.playSoundFrom(file: fileName)
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboard.delegate = self
        
        // Center button text
        example1.titleLabel?.textAlignment = NSTextAlignment.center
        example2.titleLabel?.textAlignment = NSTextAlignment.center
        example3.titleLabel?.textAlignment = NSTextAlignment.center
        
        // set up video player
        self.avPlayer = AVPlayer()
        let playerLayer: AVPlayerLayer = AVPlayerLayer(player: avPlayer)
        playerLayer.frame = videoView.bounds
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoView.layer.addSublayer(playerLayer)
        
        updateDisplayForIpa(defaultIpaToShowFirst)
        loadVideoFor(ipa: defaultIpaToShowFirst)
    }
    
    func updateDisplayForIpa(_ ipa: String) {
        guard ipaLabel.text != ipa else {return}
        guard let prefix = ipaForNamePrefix[ipa]
            else {return}
        
        ipaLabel.text = ipa
        videoView.image = UIImage(named: "\(prefix)_placeholder")
        ipaDescription.text = "\(prefix)_description".localized
        ipaDescription.scrollRangeToVisible(NSRange(location: 0, length: 0))
        example1.setTitle("\(prefix)_example1".localized, for: UIControlState())
        example2.setTitle("\(prefix)_example2".localized, for: UIControlState())
        example3.setTitle("\(prefix)_example3".localized, for: UIControlState())
    }
    
    func loadVideoFor(ipa: String) {
        // get the path string for the video from assets
        guard let writtenName = ipaForNamePrefix[ipa] else {return}
        let resourceName = "raw/v_" + writtenName
        let videoString:String? = Bundle.main.path(forResource: resourceName, ofType: "mp4")
        guard let unwrappedVideoPath = videoString else {return}
        
        // convert the path string to a url
        let videoUrl = URL(fileURLWithPath: unwrappedVideoPath)
        
        let asset = AVAsset(url: videoUrl)
        let playerItem = AVPlayerItem(asset: asset)
        avPlayer?.replaceCurrentItem(with: playerItem)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == learnDoubleSegueId {
            let learnDoubleVC = segue.destination as! LearnDoubleSoundsViewController
            learnDoubleVC.ipa = ipaLabel.text
        }
        
    }
    
    // MARK:- KeyboardDelegate methods
    
    func keyWasTapped(_ character: String) {
        updateDisplayForIpa(character)
        loadVideoFor(ipa: character)
        avPlayer?.seek(to: kCMTimeZero)
        avPlayer?.play()
    }
    
    func keyBackspace() {
        // only conforming to keyboard delegate
    }
    
    let ipaForNamePrefix = [
        "p":"p",
        "t":"t",
        "k":"k",
        "ʧ":"ch",
        "f":"f",
        "θ":"th_voiceless",
        "s":"s",
        "ʃ":"sh",
        "b":"b",
        "d":"d",
        "g":"g",
        "ʤ":"dzh",
        "v":"v",
        "ð":"th_voiced",
        "z":"z",
        "ʒ":"zh",
        "m":"m",
        "n":"n",
        "ŋ":"ng",
        "l":"l",
        "w":"w",
        "j":"j",
        "h":"h",
        "r":"r",
        "i":"i",
        "ɪ":"i_short",
        "ɛ":"e_short",
        "æ":"ae",
        "ɑ":"a",
        "ɔ":"c_backwards",
        "ʊ":"u_short",
        "u":"u",
        "ʌ":"v_upsidedown",
        "ə":"schwa",
        "eɪ":"ei",
        "aɪ":"ai",
        "aʊ":"au",
        "ɔɪ":"oi",
        "oʊ":"ou",
        "ɾ":"flap_t",
        "ɝ":"er_stressed",
        "ɚ":"er_unstressed",
        "ɑr":"ar",
        "ɛr":"er",
        "ɪr":"ir",
        "ɔr":"or",
        "ʔ":"glottal_stop"
    ]
}
