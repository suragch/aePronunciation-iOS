import UIKit

class TestViewController: UIViewController {

    
    private var answers = [Answer]()
    private let player = Player()
    private lazy var singleSound = SingleSound()
    private lazy var doubleSound = DoubleSound()
    //private var singleMode = true // false == double mode
    private var currentIpa = ""
    private var inputKeyCounter = 0
    //private var readyForNewSound = false
    //private var alreadyMadeWrongAnswerForThisIpa = false
    private var questionNumber = 0 // zero based
    private var totalNumberOfQuestions = -1
    private var examType = ExamType.Doubles
    private var startTime = NSDate()
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var questionNumberLabel: UILabel!
    @IBOutlet weak var inputWindow: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var inputWindowView: UIView!
    
    // MARK: - Actions
    
    @IBAction func playButtonTapped(sender: UIButton) {
        
        playIpa(currentIpa)
        
    }
    
    @IBAction func keyTapped(sender: UIButton) {
        
        // get ipa String for key tapped
        let ipaTap = sender.titleLabel?.text ?? ""
        
        if examType != ExamType.Doubles { // singles
            
            inputWindow.text = ipaTap
            nextButton.hidden = false
            
        } else { // doubles
            
            ++inputKeyCounter
            
            if inputKeyCounter < 3 {
                inputWindow.text = inputWindow.text! + ipaTap
            }
            
            if inputKeyCounter > 1 {
                nextButton.hidden = false
            }
        }
        
    }
    
    @IBAction func clearButtonTap(sender: UIButton) {
        
        inputWindow.text = ""
        inputKeyCounter = 0
        nextButton.hidden = true
    }
    
    
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        
        // record correct answer and user answer
        let userAnswer = inputWindow.text!
        let thisAnswer = Answer(correctAnswer: currentIpa, userAnswer: userAnswer)
        answers.append(thisAnswer)
        
        // update display
        inputWindow.text = ""
        inputKeyCounter = 0
        nextButton.hidden = true
        
        ++questionNumber
        
        if questionNumber == totalNumberOfQuestions {
            
            // TODO: Start Results View Controller with answers data
            self.performSegueWithIdentifier(Segue.testToResults, sender: self)
            
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
        let userDefaults = NSUserDefaults.standardUserDefaults()
        
        
        
        // number of questions
        let number = userDefaults.integerForKey(Key.numberOfQuestions)
        if number > 0 {
            totalNumberOfQuestions = number
        }
        // content type
        if let type = ExamType(rawValue: userDefaults.integerForKey(Key.contentType)) {
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
        nextButton.hidden = true
        playIpa(currentIpa)
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // pass the answers to the results view controller
        let resultsViewController = segue.destinationViewController as! TestResultsViewController
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
            case ExamType.Singles:
                
                randomIpa = singleSound.getRandomIpa()
                
            case ExamType.VowelsOnly:
                
                randomIpa = singleSound.getRandomVowelIpa()
                
            case ExamType.ConsonantsOnly:
                
                randomIpa = singleSound.getRandomConsonantIpa()
                
            case ExamType.Doubles:
                
                randomIpa = doubleSound.getRandomIpa()
            }
            
        } while randomIpa == currentIpa
        
        return randomIpa
    }
    
    func playIpa(ipa: String) {
        
        if examType == ExamType.Doubles {
            
            if let fileName = doubleSound.fileNameForIpa(ipa) {
                player.playSoundFromFile(fileName)
            }
            
        } else {
            
            if let fileName = singleSound.fileNameForIpa(ipa) {
                player.playSoundFromFile(fileName)
            }
        }
        
    }


}
