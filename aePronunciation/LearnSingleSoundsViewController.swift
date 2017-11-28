import UIKit
import AudioToolbox

class LearnSingleSoundsViewController: UIViewController, KeyboardDelegate {
    
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
    @IBOutlet weak var videoView: UIView!
    
    // MARK: - Actions
    
    @IBAction func example1(_ sender: UIButton) {
        guard let ipa = ipaLabel.text else {return}
        guard let fileName = SingleSound.getExampleOneFileName(ipa: ipa)
            else {return}
        player.playSoundFromFile(fileName)
    }
    
    @IBAction func example2(_ sender: UIButton) {
        guard let ipa = ipaLabel.text else {return}
        guard let fileName = SingleSound.getExampleTwoFileName(ipa: ipa)
            else {return}
        player.playSoundFromFile(fileName)
    }
    
    @IBAction func example3(_ sender: UIButton) {
        guard let ipa = ipaLabel.text else {return}
        guard let fileName = SingleSound.getExampleThreeFileName(ipa: ipa)
            else {return}
        player.playSoundFromFile(fileName)
    }
    
    @IBAction func more(_ sender: UIButton) {
        
        // TODO: Show double sounds
        // start LearnDoubleSounds, pass in the current IPA
        
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyboard.delegate = self
        
        updateDisplayForIpa(defaultIpaToShowFirst)
        
        // Center button text
        example1.titleLabel?.textAlignment = NSTextAlignment.center
        example2.titleLabel?.textAlignment = NSTextAlignment.center
        example3.titleLabel?.textAlignment = NSTextAlignment.center
    }
    
    func updateDisplayForIpa(_ ipa: String) {
        guard let prefix = ipaForNamePrefix[ipa]
            else {return}
        
        ipaLabel.text = ipa
        
        ipaDescription.text = "\(prefix)_description".localized
        ipaDescription.scrollRangeToVisible(NSRange(location: 0, length: 0))
        example1.setTitle("\(prefix)_example1".localized, for: UIControlState())
        example2.setTitle("\(prefix)_example2".localized, for: UIControlState())
        example3.setTitle("\(prefix)_example3".localized, for: UIControlState())
        
        
        
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
        
        // play sound
        if let fileName =  SingleSound.getSoundFileName(ipa: character) {
            player.playSoundFromFile(fileName)
        }
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
