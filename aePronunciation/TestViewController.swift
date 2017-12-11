import UIKit

class TestViewController: UIViewController, KeyboardDelegate {
    

    var userName = "test_default_name".localized
    var testMode = MyUserDefaults.defaultTestMode
    var totalNumberOfQuestions = MyUserDefaults.defaultNumberOfTestQuestions
    
    private var answers = [Answer]()
    private let player = Player()
    private lazy var singleSound = SingleSound()
    private lazy var doubleSound = DoubleSound()
    private var currentIpa = ""
    private var inputKeyCounter = 0
    private var readyForNewSound = true
    private var questionNumber = 0 // zero based
    private var startTime = Date().timeIntervalSince1970
    
    static let testToResultsSegue = "testToResults"
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var testModeLabel: UILabel!
    @IBOutlet weak var inputWindow: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var inputWindowView: UIView!
    @IBOutlet weak var ipaKeyboard: IpaKeyboard!
    
    // MARK: - Actions
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        
        if readyForNewSound {
            prepareForNextSound()
        }
        
        playSound(currentIpa)
    }
    
    private func prepareForNextSound() {
        currentIpa = getRandomIpa()
        readyForNewSound = false
        inputWindow.text = ""
        questionNumberLabel.text = String(questionNumber + 1)
    }
    
    @IBAction func clearButtonTap(_ sender: UIButton) {
        inputWindow.text = ""
        inputKeyCounter = 0
        nextButton.isHidden = true
    }
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        // record correct answer and user answer
        let userAnswer = inputWindow.text ?? ""
        let thisAnswer = Answer(correctAnswer: currentIpa, userAnswer: userAnswer)
        answers.append(thisAnswer)
        
        // update display
        inputWindow.text = ""
        inputKeyCounter = 0
        readyForNewSound = true
        nextButton.isHidden = true
        
        questionNumber += 1
        
        if questionNumber == totalNumberOfQuestions {
            
            saveTestToDatabase()
            self.performSegue(withIdentifier: TestViewController.testToResultsSegue, sender: self)
        } else {
            // auto play next sound
            prepareForNextSound()
            playSound(currentIpa)
        }
    }
    
    // MARK - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ipaKeyboard.delegate = self
        
        // set up display
        inputWindow.text = ""
        inputWindowView.layer.borderWidth = 2.0
        inputWindowView.layer.cornerRadius = 8
        inputWindowView.layer.masksToBounds = true
        
        // set mode label
        if testMode == SoundMode.single {
            testModeLabel.text = "practice_mode_single".localized
        } else {
            testModeLabel.text = "practice_mode_double".localized
        }
        
        // question number
        questionNumberLabel.text = String(questionNumber + 1)
        
        // TODO: Start timing the test
        
        
        // hide the next button
        nextButton.isHidden = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let testResultsVC = segue.destination as? TestResultsViewController {
            testResultsVC.userName = userName
            testResultsVC.answers = answers
            testResultsVC.timeLength = getTestTime()
            testResultsVC.testMode = testMode
        }
    }
    
    // MARK:- Keyboard Delegate
    
    func keyWasTapped(_ character: String) {
        if readyForNewSound {return}
        
        inputKeyCounter += 1
        
        if testMode == SoundMode.single {
            inputWindow.text = character
        } else if testMode == SoundMode.double && inputKeyCounter <= 2 {
            let oldText = inputWindow.text ?? ""
            let newText = oldText + character
            inputWindow.text = newText
            if oldText.isEmpty {return}
        }
        nextButton.isHidden = false
    }
    
    func keyBackspace() {}
    
    
    // MARK: - Other methods
    
    func getRandomIpa() -> String {
        var ipa = ""
        repeat {
            if testMode == SoundMode.single {
                ipa = singleSound.getRandomIpa()
            } else {
                ipa = doubleSound.getRandomIpa()
            }
        } while currentIpa == ipa // don't allow repeat sounds
        return ipa
    }
    
    func playSound(_ ipa: String) {
        var fileName: String?
        if testMode == SoundMode.single {
            fileName = SingleSound.getSoundFileName(ipa: ipa)
        } else { // double mode
            fileName = DoubleSound.getSoundFileName(doubleSoundIpa: ipa)
        }
        if let name = fileName {
            player.playSoundFrom(file: name)
        }
    }

    private func getTestTime() -> Int {
        let endTime = Date().timeIntervalSince1970
        return Int(endTime - startTime)
    }
    
    

    private func saveTestToDatabase() {
        
        // save it in a background thread
        DispatchQueue.global(qos: .background).async {
            var correctAnswersConcat = ""
            var userAnswersConcat = ""
            for answer in self.answers {
                if correctAnswersConcat != "" {
                    // comma separated values
                    correctAnswersConcat.append(",")
                    userAnswersConcat.append(",")
                }
                correctAnswersConcat.append(answer.correctAnswer)
                userAnswersConcat.append(answer.userAnswer)
            }
            let date = Int64(Date().timeIntervalSinceNow)
            let score = Test.getScorePercent(forAnswers: self.answers, testMode: self.testMode)
            let test = Test(
                id: -1,
                username: self.userName,
                date: date,
                timelength: Int64(self.getTestTime()),
                mode: self.testMode,
                score: Int64(score),
                correctAnswers: correctAnswersConcat,
                userAnswers: userAnswersConcat)
            let db = SQLiteDatabase.instance
            _ = db.addTest(test)
        }
    }
}
