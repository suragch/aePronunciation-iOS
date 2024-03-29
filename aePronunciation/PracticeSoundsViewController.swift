import UIKit

class PracticeSoundsViewController: UIViewController, KeyboardDelegate {
    
    var practiceMode: SoundMode?
    var selectedVowels = Ipa.getAllVowels()
    var selectedConsonants = Ipa.getAllConsonants()

    private let player = Player()
    private let timer = StudyTimer.sharedInstance
    private lazy var singleSound = SingleSound()
    private lazy var doubleSound = DoubleSound()
    private var numberCorrect = 0
    private var numberWrong = 0
    private var currentIpa = ""
    private var inputKeyCounter = 0
    private var readyForNewSound = true
    private var alreadyMadeWrongAnswerForThisIpa = false
    private let MINIMUM_POPULATION_SIZE_FOR_WHICH_REPEATS_NOT_ALLOWED = 4
    private let backgroundColor = UIColor.clear.cgColor
    
    
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
            inputWindowBorderView.layer.backgroundColor = backgroundColor
            inputLabel.text = ""
        }

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
        animateCorrectAnswer()
        playIpa(currentIpa)
        readyForNewSound = true
    }
    
    @IBAction func clearButtonTapped(_ sender: UIButton) {
        inputLabel.text = ""
        inputKeyCounter = 0
        inputWindowBorderView.layer.backgroundColor = backgroundColor
    }
    
    @IBAction func unwindFromTestResultsVC(segue:UIStoryboardSegue) {
        if ipaKeyboard != nil {
            updateUiForSelectedSounds()
        }
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "main_tab_practice".localized

        ipaKeyboard.delegate = self
        addBorderToInputWindow()
        if practiceMode == nil {
            practiceMode = MyUserDefaults.storedPracticeMode
        }
        updateUiForSelectedSounds()
        
        // listen for if the user leaves the app
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTiming()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.stop() 
    }
    
    @objc func appWillEnterForeground() {
        if self.viewIfLoaded?.window != nil {
            startTiming()
        }
    }
    
    @objc func appDidEnterBackground() {
        if self.viewIfLoaded?.window != nil {
            timer.stop()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let selectSoundsVC = segue.destination as? SelectSoundsViewController {
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            selectSoundsVC.previouslySelectedMode = practiceMode ?? SoundMode.single
            selectSoundsVC.previouslySelectedKeys = ipaKeyboard.getEnabledKeys()
            selectSoundsVC.callback = { soundMode, vowels, consonants in
                self.practiceMode = soundMode
                self.selectedVowels = vowels
                self.selectedConsonants = consonants
                self.updateUiForSelectedSounds()
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
    
    private func addBorderToInputWindow() {
        inputWindowBorderView.layer.borderWidth = 2.0
        inputWindowBorderView.layer.borderColor = UIColor.gray.cgColor
        inputWindowBorderView.layer.cornerRadius = 8
        inputWindowBorderView.layer.masksToBounds = true
    }
    
    private func startTiming() {
        if practiceMode == SoundMode.single {
            timer.start(type: .practiceSingle)
        } else {
            timer.start(type: .practiceDouble)
        }
    }
    
    func updateUiForSelectedSounds() {
        resetToInitialValues()
        updateKeyboard(selectedVowels: selectedVowels, selectedConsonants: selectedConsonants)
        updatePracticeModeLabel()
        updateAllowedSounds(vowels: selectedVowels, consonants: selectedConsonants)
    }
    
    private func updateKeyboard(selectedVowels: [String], selectedConsonants: [String]) {
        ipaKeyboard.mode = practiceMode ?? SoundMode.single
        var allChosenSounds = [String]()
        allChosenSounds.append(contentsOf: selectedVowels)
        allChosenSounds.append(contentsOf: selectedConsonants)
        if practiceMode == SoundMode.single {
            if allChosenSounds.count == 0 {
                allChosenSounds.append(contentsOf: Ipa.getAllVowels())
                allChosenSounds.append(contentsOf: Ipa.getAllConsonants())
            }
        } else { // double
            if selectedVowels.count == 0 {
                allChosenSounds.append(contentsOf: Ipa.getAllVowels())
            }
            if selectedConsonants.count == 0 {
                allChosenSounds.append(contentsOf: Ipa.getAllConsonants())
            }
        }
        ipaKeyboard.updateKeyAppearanceFor(selectedSounds: allChosenSounds)
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
    
    func playIpa(_ ipa: String) {
        var fileName: String?
        if practiceMode == SoundMode.single {
            fileName = SingleSound.getSoundFileName(ipa: ipa)
        } else { // double mode
            fileName = DoubleSound.getSoundFileName(doubleSoundIpa: ipa)
            
            if fileName == nil {Answer.showErrorMessageFor(ipa, in: self)}
        }
        if let name = fileName {
            player.playSoundFrom(file: name)
        }
    }
    
    func getAnswerFromInputWindow(_ newIpaGuess: String) -> String? {
        
        if newIpaGuess == "" { return nil }
        
        let windowText = inputLabel.text ?? ""
        
        if practiceMode == SoundMode.single {
            
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
        inputWindowBorderView.layer.backgroundColor = backgroundColor
        ipaKeyboard.mode = practiceMode ?? SoundMode.single
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
            self.inputWindowBorderView.layer.backgroundColor = self.backgroundColor
        }, completion: { Void in
            self.inputLabel.text = ""
        })
    }
    
}
