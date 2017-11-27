import UIKit

class PracticeSoundsViewController: UIViewController {
    
    fileprivate let player = Player()
    fileprivate lazy var singleSound = SingleSound()
    fileprivate lazy var doubleSound = DoubleSound()
    fileprivate var numberCorrect = 0
    fileprivate var numberWrong = 0
    fileprivate var singleMode = true // false == double mode
    fileprivate var currentIpa = ""
    fileprivate var inputKeyCounter = 0
    fileprivate var readyForNewSound = true
    fileprivate var alreadyMadeWrongAnswerForThisIpa = false
    fileprivate enum SingleSoundType {
        case vowelsAndConsonants
        case vowelsOnly
        case consonantsOnly
    }
    fileprivate var vowelsOrConsonants = SingleSoundType.vowelsAndConsonants
    fileprivate let rightColor = UIColor(red: 0.031, green: 0.651, blue: 0, alpha: 1) // 08a600 green

    // MARK: - Outlets
    
    @IBOutlet weak var numberCorrectLabel: UILabel!
    @IBOutlet weak var numberWrongLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var inputWindow: UILabel!
    @IBOutlet weak var singleDoubleSwitch: UIBarButtonItem!
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
            inputWindow.text = ""
            inputWindow.layer.backgroundColor = UIColor.white.cgColor
            
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
        
        inputWindow.text = currentIpa
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
            inputWindow.text = ""
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
            singleDoubleSwitch.title = "Double"
            self.navigationController?.navigationBar.topItem?.title = "Practice Single Sounds"
            self.optionsButton.isHidden = false
            self.vowelsAndConsonantsLabel.isHidden = false
        } else {
            
            self.navigationController?.navigationBar.topItem?.title = "Practice Double Sounds"
            singleDoubleSwitch.title = "Single"
            self.optionsButton.isHidden = true
            self.vowelsAndConsonantsLabel.isHidden = true
        }
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        numberCorrectLabel.textColor = rightColor
        
        resetToInitialValues()
        
        inputWindow.layer.borderWidth = 2.0
        inputWindow.layer.cornerRadius = 8
        inputWindow.layer.masksToBounds = true
        //inputWindow.backgroundColor = UIColor.clearColor()
        
    }

    // MARK: - Other

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
        
        let windowText = inputWindow.text ?? ""
        
        if singleMode {
            
            inputWindow.text = newIpaGuess
            return newIpaGuess
            
        } else { // double mode
            
            let text = windowText + newIpaGuess
            inputWindow.text = windowText + newIpaGuess
            
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
        inputWindow.text = ""
        inputWindow.layer.backgroundColor = UIColor.white.cgColor
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
                self.inputWindow.layer.backgroundColor = UIColor.green.cgColor
            })
            
        } else { // incorrect (red)
            
            // fade in
            UIView.animate(withDuration: 0.3, animations: {
                    self.inputWindow.layer.backgroundColor = UIColor.red.cgColor
                })
            // fade out
            UIView.animate(withDuration: 0.7, delay: 0, options: [.curveEaseOut], animations: { () -> Void in
                    self.inputWindow.layer.backgroundColor = UIColor.white.cgColor
                }, completion: { Void in
                    self.inputWindow.text = ""
            })
        }
    }
}
