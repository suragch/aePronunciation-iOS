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
    private let selectSoundsSegueId = "selectSoundsSegueId"
    private var previouslySelectedVowels = [String]()
    private var previouslySelectedConsonants = [String]()
    //private let rightColor = UIColor(red: 0.031, green: 0.651, blue: 0, alpha: 1) // 08a600 green
    private let MINIMUM_POPULATION_SIZE_FOR_WHICH_REPEATS_NOT_ALLOWED = 4
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var numberCorrectLabel: UILabel!
    @IBOutlet weak var numberWrongLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var inputLabel: UILabel!
    @IBOutlet weak var inputWindowBorderView: UIView!
    @IBOutlet weak var practiceModeLabel: UILabel!
    @IBOutlet weak var ipaKeyboard: IpaKeyboard!
    
    // MARK: - Actions
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        
        if readyForNewSound {
            var ipa: String?
            
            repeat {
                if practiceMode == SoundMode.single {
                    ipa = singleSound.getRandomIpa()
                } else {
                    ipa = doubleSound.getRandomIpa()
                }
                
                // allow repeated sounds for small population sizes
                if practiceMode == SoundMode.single &&
                    singleSound.getSoundCount() < MINIMUM_POPULATION_SIZE_FOR_WHICH_REPEATS_NOT_ALLOWED {
                    break
                } else if practiceMode == SoundMode.double &&
                    doubleSound.getSoundCount() < MINIMUM_POPULATION_SIZE_FOR_WHICH_REPEATS_NOT_ALLOWED {
                    break
                }
            } while ipa == currentIpa // don't allow repeat
            
            
            if let ipa = ipa {
                currentIpa = ipa
            }
            
            // reset things
            readyForNewSound = false
            alreadyMadeWrongAnswerForThisIpa = false
            inputWindowBorderView.layer.backgroundColor = UIColor.white.cgColor
            inputLabel.text = ""
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
        //animateAnswerThatIs(true)
        animateCorrectAnswer()
        playIpa(currentIpa)
        readyForNewSound = true
    }
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        inputLabel.text = ""
        inputKeyCounter = 0
        inputWindowBorderView.layer.backgroundColor = UIColor.white.cgColor
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
            animateCorrectAnswer()
            
            // update label
            if !alreadyMadeWrongAnswerForThisIpa {
                numberCorrect += 1
            }
            
            // reset values
            readyForNewSound = true
            
            
        } else { // wrong answer
            
            // turn the input window red
            animateWrongAnswer()
            //animateAnswerThatIs(false)
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
    
//    @IBAction func switchSingleDoubleTapped(_ sender: UIBarButtonItem) {
//        
//        singleMode = !singleMode
//        resetToInitialValues()
//        
//        if singleMode {
//            //singleDoubleSwitch.title = "Double"
//            self.navigationController?.navigationBar.topItem?.title = "Practice Single Sounds"
//            self.optionsButton.isHidden = false
//            self.practiceModeLabel.isHidden = false
//        } else {
//            
//            self.navigationController?.navigationBar.topItem?.title = "Practice Double Sounds"
//            //singleDoubleSwitch.title = "Single"
//            self.optionsButton.isHidden = true
//            self.practiceModeLabel.isHidden = true
//        }
//    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ipaKeyboard.delegate = self
        addBorderToInputWindow()
        practiceMode = MyUserDefaults.storedPracticeMode
        resetToInitialValues()
        updateStatLabels()
    }
    
    private func addBorderToInputWindow() {
        inputWindowBorderView.layer.borderWidth = 2.0
        inputWindowBorderView.layer.cornerRadius = 8
        inputWindowBorderView.layer.masksToBounds = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
//        if segue.identifier == selectSoundsSegueId {
//            // hide the back button text
//            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
//            
//            //let selectSoundsVC = segue.destination as! SelectSoundsViewController
//            //selectSoundsVC
//            //learnDoubleVC.ipa = ipaLabel.text
//        }
        
        if let selectSoundsVC = segue.destination as? SelectSoundsViewController {
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            selectSoundsVC.previouslySelectedMode = practiceMode
            selectSoundsVC.previouslySelectedVowels = previouslySelectedVowels
            selectSoundsVC.previouslySelectedConsonants = previouslySelectedVowels
            selectSoundsVC.callback = { soundMode, vowels, consonants in
                self.updateUiForSelectedSounds(
                    soundMode: soundMode,
                    selectedVowels: vowels,
                    selectedConsonants: consonants)
            }
        }
    }
    
    // MARK: - KeyboardDelegate methods
    
    func keyWasTapped(_ character: String) {
        // don't allow more clicks when green
        if readyForNewSound {return}
        
        if practiceMode == SoundMode.double && inputKeyCounter >= 2 {
            inputLabel.text = ""
            inputKeyCounter = 0
        }
        inputKeyCounter += 1
        
        // add text to input window
        if practiceMode == SoundMode.single {
            inputLabel.text = character
        } else {
            guard let oldText = inputLabel.text, oldText != "" else {
                inputLabel.text = character
                return
            }
            inputLabel.text = oldText + character
        }
        
        let userAnswer = inputLabel.text
        
        // check if right or not
        if userAnswer == currentIpa {
            // if right then animate backgound to green and back
            animateCorrectAnswer()
            
            // update label
            if !alreadyMadeWrongAnswerForThisIpa {
                numberCorrect += 1
            }
            
            readyForNewSound = true
            
        } else { // wrong answer
            
            // if wrong then animate to red and back
            animateWrongAnswer()
            
            // update label
            if !alreadyMadeWrongAnswerForThisIpa {
                numberWrong += 1
                alreadyMadeWrongAnswerForThisIpa = true
            }
            
            // play sound that was pressed
            if let ipa = userAnswer {
                playIpa(ipa)
            }
            
        }
        
        updateStatLabels()
    }
    
    func keyBackspace() {
        // only here to conform to delegate
    }

    // MARK: - Other
    
    private func updateUiForSelectedSounds(soundMode: SoundMode, selectedVowels: [String], selectedConsonants: [String]) {
        resetToInitialValues()
        
        practiceMode = soundMode
        
        // update keyboard
        updateKeyboard(selectedVowels: selectedVowels, selectedConsonants: selectedConsonants)
        updateUserPreferencesAndTime()
        updatePracticeModeLabel()
        updateAllowedSounds(vowels: selectedVowels, consonants: selectedConsonants)
        saveSelectedSoundState(vowels: selectedVowels, consonants: selectedConsonants)
    }
    
    private func updateKeyboard(selectedVowels: [String], selectedConsonants: [String]) {
        ipaKeyboard.mode = practiceMode
        var allChosenSounds = [String]()
        allChosenSounds.append(contentsOf: selectedVowels)
        allChosenSounds.append(contentsOf: selectedConsonants)
        if practiceMode == SoundMode.double {
            if selectedVowels.count == 0 {
                allChosenSounds.append(contentsOf: Ipa.getAllVowels())
            }
            if selectedConsonants.count == 0 {
                allChosenSounds.append(contentsOf: Ipa.getAllConsonants())
            }
        }
        ipaKeyboard.updateKeyAppearanceFor(selectedSounds: allChosenSounds)
    }
    
    private func updateUserPreferencesAndTime() {
        // TODO
    }
    
    private func updatePracticeModeLabel() {
        if practiceMode == SoundMode.single {
            practiceModeLabel.text = "practice_mode_single".localized
        } else {
            practiceModeLabel.text = "practice_mode_double".localized
        }
    }
    
    private func updateAllowedSounds(vowels: [String], consonants: [String]) {
        if practiceMode == SoundMode.single {
            singleSound.restrictListTo(consonants: consonants, vowels: vowels)
        } else { // double
            if (vowels.count == 0 && consonants.count == 0) ||
                (vowels.count == Ipa.NUMBER_OF_VOWELS_FOR_DOUBLES && consonants.count == Ipa.NUMBER_OF_CONSONANTS_FOR_DOUBLES) {
                // all or none selected
                doubleSound.includeAllSounds()
            } else if vowels.count == 0 || consonants.count == 0 {
                // if none of one kind and a few of the other kind,
                // then do inclusive match (any containing pair)
                doubleSound.restrictListToPairsContainingAtLeastOneSoundFrom(consonants: consonants, vowels: vowels)
                
            } else {
                // if a few of both kinds, then do exact match (both members must match)
                doubleSound.restrictListToPairsContainingBothSoundsFrom(consonants: consonants, vowels: vowels)
            }
        }
    }
    
    private func saveSelectedSoundState(vowels: [String], consonants: [String]) {
        previouslySelectedVowels = vowels
        previouslySelectedConsonants = consonants
    }
    
    func playIpa(_ ipa: String) {
        var fileName: String?
        if practiceMode == SoundMode.single {
            fileName = SingleSound.getSoundFileName(ipa: ipa)
        } else { // double mode
            fileName = DoubleSound.getSoundFileName(doubleSoundIpa: ipa)
            
            if fileName == nil {showErrorMessageFor(ipa)}
        }
        if let name = fileName {
            player.playSoundFrom(file: name)
        }
    }
    
    private func showErrorMessageFor(_ ipa: String) {
        
        let errorMessage = Answer.getErrorMessage(doubleIpa: ipa)
        let ok = "error_dialog_ok_button".localized
        
        // create the alert
        let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: ok, style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
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
        inputWindowBorderView.layer.backgroundColor = UIColor.white.cgColor
        if practiceMode == SoundMode.single {
            practiceModeLabel.text = "practice_mode_single".localized
        } else {
            practiceModeLabel.text = "practice_mode_double".localized
        }
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
    
    func animateCorrectAnswer() { // (green)
        UIView.animate(withDuration: 0.3, animations: {
            self.inputWindowBorderView.layer.backgroundColor = UIColor.rightGreen.cgColor
        })
    }
    
    func animateWrongAnswer() { // (red)
        // fade in
        UIView.animate(withDuration: 0.3, animations: {
            self.inputWindowBorderView.layer.backgroundColor = UIColor.red.cgColor
        })
        // fade out
        UIView.animate(withDuration: 0.7, delay: 0, options: [.curveEaseOut], animations: { () -> Void in
            self.inputWindowBorderView.layer.backgroundColor = UIColor.white.cgColor
        }, completion: { Void in
            self.inputLabel.text = ""
        })
    }
    
}
