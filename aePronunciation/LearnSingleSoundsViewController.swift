import UIKit
import AudioToolbox

class LearnSingleSoundsViewController: UIViewController {
    
    fileprivate let player = Player()
    fileprivate let defaultIpaToShowFirst = "æ"
    fileprivate let singleSound = SingleSound()

    // MARK: - Outlets
    
    @IBOutlet weak var ipaLabel: UILabel!
    @IBOutlet weak var ipaDescription: UITextView!
    @IBOutlet weak var example1: UIButton!
    @IBOutlet weak var example2: UIButton!
    @IBOutlet weak var example3: UIButton!
    
    // MARK: - Actions
    
    @IBAction func keyTapped(_ sender: UIButton) {
        
        let buttonText = sender.titleLabel?.text ?? ""
        
        updateDisplayForIpa(buttonText)
        
        // play sound
        if let fileName = singleSound.fileNameForIpa(buttonText) {
            player.playSoundFromFile(fileName)
        }
        
    }
    
    @IBAction func example1(_ sender: UIButton) {
        
        
        if let ipa = ipaLabel.text {
            if let fileName = singleSound.exampleOneFileNameFromIpa(ipa) {
                player.playSoundFromFile(fileName)
            }
        }
        
    }
    
    @IBAction func example2(_ sender: UIButton) {
        
        if let ipa = ipaLabel.text {
            if let fileName = singleSound.exampleTwoFileNameFromIpa(ipa) {
                player.playSoundFromFile(fileName)
            }
        }
    }
    
    @IBAction func example3(_ sender: UIButton) {
        
        if let ipa = ipaLabel.text {
            if let fileName = singleSound.exampleThreeFileNameFromIpa(ipa) {
                player.playSoundFromFile(fileName)
            }
        }
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update display with default IPA
        updateDisplayForIpa(defaultIpaToShowFirst)
        
        // Center button text
        example1.titleLabel?.textAlignment = NSTextAlignment.center
        example2.titleLabel?.textAlignment = NSTextAlignment.center
        example3.titleLabel?.textAlignment = NSTextAlignment.center
    }
    
    
    
    func updateDisplayForIpa(_ ipa: String) {
        
        if let fileName = singleSound.fileNameForIpa(ipa) {
            
            ipaLabel.text = ipa
            ipaDescription.text = "\(fileName)_description".localized
            ipaDescription.scrollRangeToVisible(NSRange(location: 0, length: 0))
            example1.setTitle("\(fileName)_example1".localized, for: UIControlState())
            example2.setTitle("\(fileName)_example2".localized, for: UIControlState())
            example3.setTitle("\(fileName)_example3".localized, for: UIControlState())
            
        }
    }
    
}
