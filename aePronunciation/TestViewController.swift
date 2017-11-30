import UIKit

class TestViewController: UIViewController {

    
    fileprivate var answers = [Answer]()
    fileprivate let player = Player()
    fileprivate lazy var singleSound = SingleSound()
    fileprivate lazy var doubleSound = DoubleSound()
    //private var singleMode = true // false == double mode
    fileprivate var currentIpa = ""
    fileprivate var inputKeyCounter = 0
    //private var readyForNewSound = false
    //private var alreadyMadeWrongAnswerForThisIpa = false
    fileprivate var questionNumber = 0 // zero based
    fileprivate var totalNumberOfQuestions = -1
    fileprivate var examType = ExamType.doubles
    fileprivate var startTime = Date()
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var inputWindow: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var inputWindowView: UIView!
    
    // MARK: - Actions
    
    @IBAction func playButtonTapped(_ sender: UIButton) {
        
        playIpa(currentIpa)
        
    }
    
    @IBAction func keyTapped(_ sender: UIButton) {
        
        // get ipa String for key tapped
        let ipaTap = sender.titleLabel?.text ?? ""
        
        if examType != ExamType.doubles { // singles
            
            inputWindow.text = ipaTap
            nextButton.isHidden = false
            
        } else { // doubles
            
            inputKeyCounter += 1
            
            if inputKeyCounter < 3 {
                inputWindow.text = inputWindow.text! + ipaTap
            }
            
            if inputKeyCounter > 1 {
                nextButton.isHidden = false
            }
        }
        
    }
    
    @IBAction func clearButtonTap(_ sender: UIButton) {
        
        inputWindow.text = ""
        inputKeyCounter = 0
        nextButton.isHidden = true
    }
    
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        
        // record correct answer and user answer
        let userAnswer = inputWindow.text!
        let thisAnswer = Answer(correctAnswer: currentIpa, userAnswer: userAnswer)
        answers.append(thisAnswer)
        
        // update display
        inputWindow.text = ""
        inputKeyCounter = 0
        nextButton.isHidden = true
        
        questionNumber += 1
        
        if questionNumber == totalNumberOfQuestions {
            
            // TODO: Start Results View Controller with answers data
            self.performSegue(withIdentifier: Segue.testToResults, sender: self)
            
        } else {
            
            // play next sound
            currentIpa = getRandomIpa()
            playIpa(currentIpa)
            
            questionNumberLabel.text = String(questionNumber + 1)
            
        }
    }
    
    // MARK - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get values set in test setup
        let userDefaults = UserDefaults.standard
        
        
        
        // number of questions
        let number = userDefaults.integer(forKey: Key.numberOfQuestions)
        if number > 0 {
            totalNumberOfQuestions = number
        }
        // content type
        if let type = ExamType(rawValue: userDefaults.integer(forKey: Key.contentType)) {
            examType = type
        }
        
        
        
        // set up display
        inputWindow.text = ""
        inputWindowView.layer.borderWidth = 2.0
        inputWindowView.layer.cornerRadius = 8
        inputWindowView.layer.masksToBounds = true
        questionNumberLabel.text = String(questionNumber + 1)
        
        // play first sound
        currentIpa = getRandomIpa()
        nextButton.isHidden = true
        playIpa(currentIpa)
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // pass the answers to the results view controller
        let resultsViewController = segue.destination as! TestResultsViewController
        resultsViewController.testAnswers = answers
        resultsViewController.startTime = startTime
        resultsViewController.examType = examType
    }
    
    // MARK: - Other methods
    
    func getRandomIpa() -> String {
        
        var randomIpa = ""
        
        // don't allow repeated ipa sounds
        repeat {
        
            switch examType {
            case ExamType.singles:
                
                randomIpa = singleSound.getRandomIpa()
                
            case ExamType.vowelsOnly:
                
                randomIpa = singleSound.getRandomIpa()
                
            case ExamType.consonantsOnly:
                
                randomIpa = singleSound.getRandomIpa()
                
            case ExamType.doubles:
                
                randomIpa = doubleSound.getRandomIpa()
            }
            
        } while randomIpa == currentIpa
        
        return randomIpa
    }
    
    func playIpa(_ ipa: String) {
        
        if examType == ExamType.doubles {
            
            if let fileName = DoubleSound.getSoundFileName(doubleSoundIpa: ipa) {
                player.playSoundFrom(file: fileName)
            }
            
        } else {
            
            if let fileName = SingleSound.getSoundFileName(ipa: ipa) {
                player.playSoundFrom(file: fileName)
            }
        }
        
    }


}
