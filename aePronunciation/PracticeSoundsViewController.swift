import UIKit

class PracticeSoundsViewController: UIViewController {
    
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
    private enum SingleSoundType {
        case VowelsAndConsonants
        case VowelsOnly
        case ConsonantsOnly
    }
    private var vowelsOrConsonants = SingleSoundType.VowelsAndConsonants
    private let rightColor = UIColor(red: 0.031, green: 0.651, blue: 0, alpha: 1) // 08a600 green

    // MARK: - Outlets
    
    @IBOutlet weak var numberCorrectLabel: UILabel!
    @IBOutlet weak var numberWrongLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var inputWindow: UILabel!
    @IBOutlet weak var singleDoubleSwitch: UIBarButtonItem!
    @IBOutlet weak var vowelsAndConsonantsLabel: UILabel!
    @IBOutlet weak var optionsButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func playButtonTapped(sender: UIButton) {
        
        if readyForNewSound {
            
            // get random ipa
            currentIpa = getRandomIpa()
            
            // reset things
            readyForNewSound = false
            alreadyMadeWrongAnswerForThisIpa = false
            inputWindow.text = ""
            inputWindow.layer.backgroundColor = UIColor.whiteColor().CGColor
            
        }
        
        // play sound
        playIpa(currentIpa)
        
    }
    @IBAction func tellMeButtonTapped(sender: UIButton) {
        
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
    @IBAction func optionsButtonTapped(sender: AnyObject) {
        
        // start an action sheet to choose type
        
        // Create the action sheet
        let myActionSheet = UIAlertController(title: "Content", message: "Which sounds do you want to practice?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        // Vowels and consonants
        let vowelsAndConsonantsAction = UIAlertAction(title: "Vowels and Consonants", style: UIAlertActionStyle.Default) { (action) in
            
            self.vowelsOrConsonants = SingleSoundType.VowelsAndConsonants
            self.vowelsAndConsonantsLabel.text = "Vowels and Consonants"
            self.resetToInitialValues()
        }
        
        // vowels only
        let vowelsAction = UIAlertAction(title: "Vowels Only", style: UIAlertActionStyle.Default) { (action) in
            
            self.vowelsOrConsonants = SingleSoundType.VowelsOnly
            self.vowelsAndConsonantsLabel.text = "Vowels Only"
            self.resetToInitialValues()
        }
        
        // consonants only
        let consonantsAction = UIAlertAction(title: "Consonants Only", style: UIAlertActionStyle.Default) { (action) in
            
            self.vowelsOrConsonants = SingleSoundType.ConsonantsOnly
            self.vowelsAndConsonantsLabel.text = "Consonants Only"
            self.resetToInitialValues()
        }
        
        // cancel
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) in
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
        self.presentViewController(myActionSheet, animated: true, completion: nil)
    }
    
    @IBAction func keyTapped(sender: UIButton) {
        
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
    
    @IBAction func switchSingleDoubleTapped(sender: UIBarButtonItem) {
        
        singleMode = !singleMode
        resetToInitialValues()
        
        if singleMode {
            singleDoubleSwitch.title = "Double"
            self.navigationController?.navigationBar.topItem?.title = "Practice Single Sounds"
            self.optionsButton.hidden = false
            self.vowelsAndConsonantsLabel.hidden = false
        } else {
            
            self.navigationController?.navigationBar.topItem?.title = "Practice Double Sounds"
            singleDoubleSwitch.title = "Single"
            self.optionsButton.hidden = true
            self.vowelsAndConsonantsLabel.hidden = true
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
                
                switch vowelsOrConsonants {
                case SingleSoundType.VowelsAndConsonants:
                    
                    randomIpa = singleSound.getRandomIpa()
                    
                case SingleSoundType.VowelsOnly:
                    
                    randomIpa = singleSound.getRandomVowelIpa()
                    
                case SingleSoundType.ConsonantsOnly:
                    
                    randomIpa = singleSound.getRandomConsonantIpa()
                }
                
            } else { // double mode
                
                randomIpa = doubleSound.getRandomIpa()
            }
            
        } while randomIpa == currentIpa
        
        return randomIpa
    }
    
    func playIpa(ipa: String) {
        
        if singleMode {
            
            if let fileName = singleSound.fileNameForIpa(ipa) {
                player.playSoundFromFile(fileName)
            }
            
        } else { // double mode
            
            if let fileName = doubleSound.fileNameForIpa(ipa) {
                player.playSoundFromFile(fileName)
            }
        }
    }
    
    func getAnswerFromInputWindow(newIpaGuess: String) -> String? {
        
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
        inputWindow.layer.backgroundColor = UIColor.whiteColor().CGColor
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
    
    func animateAnswerThatIs(correct: Bool) {
        
        if correct { // (green)
            
            UIView.animateWithDuration(0.3, animations: {
                self.inputWindow.layer.backgroundColor = UIColor.greenColor().CGColor
            })
            
        } else { // incorrect (red)
            
            // fade in
            UIView.animateWithDuration(0.3, animations: {
                    self.inputWindow.layer.backgroundColor = UIColor.redColor().CGColor
                })
            // fade out
            UIView.animateWithDuration(0.7, delay: 0, options: [.CurveEaseOut], animations: { () -> Void in
                    self.inputWindow.layer.backgroundColor = UIColor.whiteColor().CGColor
                }, completion: { Void in
                    self.inputWindow.text = ""
            })
        }
    }
}
