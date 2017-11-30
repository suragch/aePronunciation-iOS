import UIKit

class PracticeSoundsViewController: UIViewController, KeyboardDelegate {

    private let player = Player()
    private lazy var singleSound = SingleSound()
    private lazy var doubleSound = DoubleSound()
    private var numberCorrect = 0
    private var numberWrong = 0
    private var singleMode = true // false == double mode
    private var currentIpa = ""
    private var inputKeyCounter = 0
    private var readyForNewSound = true
    private var alreadyMadeWrongAnswerForThisIpa = false
    private var practiceMode = SoundMode.single
    private enum SingleSoundType {
        case vowelsAndConsonants
        case vowelsOnly
        case consonantsOnly
    }
    private var vowelsOrConsonants = SingleSoundType.vowelsAndConsonants
    private let rightColor = UIColor(red: 0.031, green: 0.651, blue: 0, alpha: 1) // 08a600 green

    // MARK: - Outlets
    
    @IBOutlet weak var numberCorrectLabel: UILabel!
    @IBOutlet weak var numberWrongLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var inputWindowBorderView: UIView!
    @IBOutlet weak var vowelsAndConsonantsLabel: UILabel!
    @IBOutlet weak var optionsButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        
        if readyForNewSound {
            
            // get random ipa
            currentIpa = getRandomIpa()
            
            // reset things
            readyForNewSound = false
            alreadyMadeWrongAnswerForThisIpa = false
            inputLabel.text = ""
            inputLabel.layer.backgroundColor = UIColor.white.cgColor
            
        }
        
        // play sound
        playIpa(currentIpa)
        
    }
    @IBAction func tellMeButtonTapped(_ sender: UIButton) {
        
        if readyForNewSound {
            return
        }
        
        if !alreadyMadeWrongAnswerForThisIpa {
            numberWrong += 1
            updateStatLabels()
        }
        
        inputLabel.text = currentIpa
        animateAnswerThatIs(true)
        //inputWindow.backgroundColor = UIColor.greenColor()
        playIpa(currentIpa)
        readyForNewSound = true
        
    }
    @IBAction func optionsButtonTapped(_ sender: AnyObject) {
        
        // start an action sheet to choose type
        
        // Create the action sheet
        let myActionSheet = UIAlertController(title: "Content", message: "Which sounds do you want to practice?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        // Vowels and consonants
        let vowelsAndConsonantsAction = UIAlertAction(title: "Vowels and Consonants", style: UIAlertActionStyle.default) { (action) in
            
            self.vowelsOrConsonants = SingleSoundType.vowelsAndConsonants
            self.vowelsAndConsonantsLabel.text = "Vowels and Consonants"
            self.resetToInitialValues()
        }
        
        // vowels only
        let vowelsAction = UIAlertAction(title: "Vowels Only", style: UIAlertActionStyle.default) { (action) in
            
            self.vowelsOrConsonants = SingleSoundType.vowelsOnly
            self.vowelsAndConsonantsLabel.text = "Vowels Only"
            self.resetToInitialValues()
        }
        
        // consonants only
        let consonantsAction = UIAlertAction(title: "Consonants Only", style: UIAlertActionStyle.default) { (action) in
            
            self.vowelsOrConsonants = SingleSoundType.consonantsOnly
            self.vowelsAndConsonantsLabel.text = "Consonants Only"
            self.resetToInitialValues()
        }
        
        // cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) in
            // do nothing
        }
        
        // add action buttons to action sheet
        myActionSheet.addAction(vowelsAndConsonantsAction)
        myActionSheet.addAction(vowelsAction)
        myActionSheet.addAction(consonantsAction)
        myActionSheet.addAction(cancelAction)
        
        // support iPads (popover)
        myActionSheet.popoverPresentationController?.sourceView = self.optionsButton
        myActionSheet.popoverPresentationController?.sourceRect = self.optionsButton.bounds
        
        // present the action sheet
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    @IBAction func keyTapped(_ sender: UIButton) {
        
        // User must listen to practice sound before pressing a key
        if readyForNewSound {
            return
        }
        
        if !singleMode && inputKeyCounter >= 2 {
            inputLabel.text = ""
            inputKeyCounter = 0
        }
        inputKeyCounter += 1
        
        // get ipa String for key tapped
        let ipaTap = sender.titleLabel?.text ?? ""
        
        // get answer
        let answer = getAnswerFromInputWindow(ipaTap)
        if answer == nil {return}
        
        // check if answer is correct
        if answer! == currentIpa {
            
            // turn the input window green
            animateAnswerThatIs(true)
            //inputWindow.backgroundColor = UIColor.greenColor()
            
            // update label
            if !alreadyMadeWrongAnswerForThisIpa {
                numberCorrect += 1
            }
            
            // reset values
            readyForNewSound = true
            
            
        } else { // wrong answer
            
            // turn the input window red
            animateAnswerThatIs(false)
            //inputWindow.backgroundColor = UIColor.redColor()
            
            // update label
            if !alreadyMadeWrongAnswerForThisIpa {
                numberWrong += 1
                alreadyMadeWrongAnswerForThisIpa = true
            }
            
            // play wrong sound
            playIpa(answer!)
            
        }
        
        updateStatLabels()
        
    }
    
    @IBAction func switchSingleDoubleTapped(_ sender: UIBarButtonItem) {
        
        singleMode = !singleMode
        resetToInitialValues()
        
        if singleMode {
            //singleDoubleSwitch.title = "Double"
            self.navigationController?.navigationBar.topItem?.title = "Practice Single Sounds"
            self.optionsButton.isHidden = false
            self.vowelsAndConsonantsLabel.isHidden = false
        } else {
            
            self.navigationController?.navigationBar.topItem?.title = "Practice Double Sounds"
            //singleDoubleSwitch.title = "Single"
            self.optionsButton.isHidden = true
            self.vowelsAndConsonantsLabel.isHidden = true
        }
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        numberCorrectLabel.textColor = rightColor
        
        resetToInitialValues()
        
        inputWindowBorderView.layer.borderWidth = 2.0
        inputWindowBorderView.layer.cornerRadius = 8
        inputWindowBorderView.layer.masksToBounds = true
        
        practiceMode = MyUserDefaults.storedPracticeMode
        //updatePracticeModeFromUserDefaults()
        
    }
    
    // MARK: - KeyboardDelegate methods
    
    func keyWasTapped(_ character: String) {
        print("key tapped")
    }
    
    func keyBackspace() {
        // only here to conform to delegate
    }

    // MARK: - Other

    private func updatePracticeModeFromUserDefaults() {
        practiceMode
        let spracticeMode = UserDefaults.standard.bool(forKey: MyUserDefaults.PRACTICE_MODE_IS_SINGLE_KEY)
        
    }
    
    func getRandomIpa() -> String {
        
        var randomIpa = ""
        
        // don't allow repeats
        repeat {
            
            if singleMode {
                
//                switch vowelsOrConsonants {
//                case SingleSoundType.vowelsAndConsonants:
//
//                    randomIpa = singleSound.getRandomIpa()
//
//                case SingleSoundType.vowelsOnly:
//
//                    randomIpa = singleSound.getRandomVowelIpa()
//
//                case SingleSoundType.consonantsOnly:
//
//                    randomIpa = singleSound.getRandomConsonantIpa()
//                }
                
            } else { // double mode
                
                randomIpa = doubleSound.getRandomIpa()
            }
            
        } while randomIpa == currentIpa
        
        return randomIpa
    }
    
    func playIpa(_ ipa: String) {
        
//        if singleMode {
//            
//            if let fileName = singleSound.fileNameForIpa(ipa) {
//                player.playSoundFromFile(fileName)
//            }
//            
//        } else { // double mode
//            
//            if let fileName = doubleSound.fileNameForIpa(ipa) {
//                player.playSoundFromFile(fileName)
//            }
//        }
    }
    
    func getAnswerFromInputWindow(_ newIpaGuess: String) -> String? {
        
        if newIpaGuess == "" { return nil }
        
        let windowText = inputLabel.text ?? ""
        
        if singleMode {
            
            inputLabel.text = newIpaGuess
            return newIpaGuess
            
        } else { // double mode
            
            let text = windowText + newIpaGuess
            inputLabel.text = windowText + newIpaGuess
            
            // check if this is the first input
            if windowText == "" {
                return nil
            }
            
            return text
        }
        
    }
    
    func resetToInitialValues() {
    
        readyForNewSound = true
        numberCorrect = 0
        numberWrong = 0
        updateStatLabels()
        inputKeyCounter = 0
        inputLabel.text = ""
        inputLabel.layer.backgroundColor = UIColor.white.cgColor
    }
    
    func updateStatLabels() {
        numberCorrectLabel.text = "\(numberCorrect)"
        numberWrongLabel.text = "\(numberWrong)"
        if numberCorrect + numberWrong > 0 {
            let percent = "\(Int(Double(numberCorrect)/Double((numberCorrect + numberWrong))*100))%"
            percentLabel.text = "\(percent)"
        } else {
            percentLabel.text = "0%"
        }
        
    }
    
    func animateAnswerThatIs(_ correct: Bool) {
        
        if correct { // (green)
            
            UIView.animate(withDuration: 0.3, animations: {
                self.inputLabel.layer.backgroundColor = UIColor.green.cgColor
            })
            
        } else { // incorrect (red)
            
            // fade in
            UIView.animate(withDuration: 0.3, animations: {
                    self.inputLabel.layer.backgroundColor = UIColor.red.cgColor
                })
            // fade out
            UIView.animate(withDuration: 0.7, delay: 0, options: [.curveEaseOut], animations: { () -> Void in
                    self.inputLabel.layer.backgroundColor = UIColor.white.cgColor
                }, completion: { Void in
                    self.inputLabel.text = ""
            })
        }
    }
}
