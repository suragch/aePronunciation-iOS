import UIKit

class TestResultsViewController: UIViewController {

    // values passed in from previous view controller
    var userName = "test_default_name".localized
    var timeLength: TimeInterval = 0
    var answers = [Answer]()
    var testMode = MyUserDefaults.defaultTestMode
    
    private var score = 0
    private var wrong = ""
    private let cellReuseIdentifier = "cell"
    private let rightColor = UIColor.rightGreen
    private let wrongColor = UIColor.red
    private let player = Player()
    private lazy var singleSound = SingleSound()
    private lazy var doubleSound = DoubleSound()
    
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    //@IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var wrongLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var practiceButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func practiceDifficultButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func timeButtonTapped(_ sender: UIButton) {
        
        // get the time strings
        let formatter = DateFormatter()
        formatter.timeStyle = DateFormatter.Style.medium
        formatter.locale = Locale(identifier: "en_US_POSIX")
        let startTimeString = formatter.string(from: startTime)
        let endTimeString = formatter.string(from: endTime)
        
        // create the message from the time strings
        let message = "Start time: \(startTimeString)\nEndTime: \(endTimeString)"
        
        // start an alert with start and stop time
        let alert = UIAlertController(title: "Test Time Length", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // name
        userNameLabel.text = userName
        
        // date
        dateLabel.text = getFormattedDate()
        
        // calculate score
        let numberCorrect = calculateNumberCorrect()
        var totalNumber = answers.count
        if testMode == SoundMode.double {
            totalNumber *= 2
        }
        let score = (numberCorrect * 100) / totalNumber // round down
        percentLabel.text = String.localizedStringWithFormat("test_results_percent".localized, score)
        rightLabel.text = String.localizedStringWithFormat("test_results_right".localized, numberCorrect)
        let numberWrong = totalNumber - numberCorrect
        wrongLabel.text =  String.localizedStringWithFormat("test_results_wrong".localized, numberWrong)
        
        // Show elapsed time
        timeLabel.text = getTimeString()
        
        // register UITableViewCell for reuse
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        // Add test to database
    }
    
    // MARK: - Table View methods
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.testAnswers.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // make attributes
        let correctAnswer = self.testAnswers[indexPath.row].correctAnswer
        let correctAnswerAttr = NSAttributedString(string: correctAnswer, attributes: [NSAttributedStringKey.foregroundColor: rightColor])
        let userAnswer = self.testAnswers[indexPath.row].userAnswer
        let userAnswerAttr = attributedTextForUserAnswer(userAnswer, correctAnswer: correctAnswer)
        
        // build string
        let attributedString = NSMutableAttributedString(string: "\(indexPath.row + 1).  ")
        attributedString.append(correctAnswerAttr)
        attributedString.append(NSAttributedString(string: "  "))
        attributedString.append(userAnswerAttr)
        
        // set label text
        cell.textLabel?.attributedText = attributedString
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        let answer = answers[indexPath.row]
        let correctAnswer = answer.correctAnswer
        let userAnswer = answer.userAnswer
        
        // play sounds
        playIpa(correctAnswer)
        if correctAnswer != userAnswer {
            var delayTime = 1.0
            if Ipa.hasTwoPronunciations(ipa: correctAnswer) {
                delayTime = 2.0  // these sounds needs more time to finish
            }
            delay(delayTime) {
                self.playIpa(userAnswer)
            }
        }
    }
    
    // MARK: - Other methods
    
    private func getFormattedDate() -> String {
        // Set the date
        let now = Date()
        let formatter = DateFormatter()
        formatter.locale = getLocale()
        formatter.dateStyle = DateFormatter.Style.long
        return formatter.string(from: now)
    }
    
    private func getLocale() -> Locale {
        // This allows the date to only be formatted for the translated
        // languages. All others will use the US English format.
        let currentTranslationLocale = "locale".localized
        switch currentTranslationLocale {
        case "zh_Hans":
            return Locale(identifier: "zh_Hans") // Simplified Chinese
        case "zh_Hant":
            return Locale(identifier: "zh_Hant") // Traditional Chinese
        default:
            return Locale(identifier: "en_US_POSIX") // US English
        }
    }

    func getTimeString() -> String {
        let interval = Int(timeLength)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    func calculateNumberCorrect() -> Int {
    
        // count number correct
        var numCorrect = 0
        for answer in answers {
            let correct = answer.correctAnswer
            let user = answer.userAnswer
            
            // Single
            if testMode == SoundMode.single && correct == user {
                numCorrect += 1
                continue
            }
            
            // Double
            guard let parsedCorrect = DoubleSound.parse(ipaDouble: correct) else {continue}
            guard let parsedUser = DoubleSound.parse(ipaDouble: user) else {continue}
            if parsedCorrect.0 == parsedUser.0 {
                numCorrect += 1
            }
            if parsedCorrect.1 == parsedUser.1 {
                numCorrect += 1
            }
        }
        return numCorrect
    }
    
    private func findNeedToPracticeSounds(answers: [Answer]) -> Set<String> {
        var practiceSet = Set<String>()
        for answer in answers {
            let user = answer.userAnswer
            let correct = answer.correctAnswer
            
            if testMode == SoundMode.single {
                if user != correct {
                    practiceSet.insert(user)
                    practiceSet.insert(correct)
                }
            } else { // Double
                guard let parsedCorrect = DoubleSound.parse(ipaDouble: correct) else {continue}
                guard let parsedUser = DoubleSound.parse(ipaDouble: user) else {continue}
                if parsedCorrect.0 != parsedUser.0 {
                    practiceSet.insert(parsedCorrect.0)
                    practiceSet.insert(parsedUser.0)
                }
                if parsedCorrect.1 == parsedUser.1 {
                    practiceSet.insert(parsedCorrect.1)
                    practiceSet.insert(parsedUser.1)
                }
            }
        }
        return practiceSet
    }
    
    func attributedTextForUserAnswer(_ userAnswer: String, correctAnswer: String) -> NSAttributedString {
    
        let returnString = NSMutableAttributedString()
        
        // don't reprint answer if correct
        if userAnswer == correctAnswer {
            return returnString
        }
        
        // color user's wrong answer red
        if examType == ExamType.doubles {
            
            
//            let (correctFirst, correctSecond) = doubleSound.parse(correctAnswer)!
//            if let (userFirst, userSecond) = doubleSound.parse(userAnswer) {
//
//                // first part
//                if userFirst != correctFirst {
//                    // red
//                    returnString.append(NSAttributedString(string: userFirst, attributes: [NSAttributedStringKey.foregroundColor: wrongColor]))
//                } else {
//                    // green
//                    returnString.append(NSAttributedString(string: userFirst, attributes: [NSAttributedStringKey.foregroundColor: rightColor]))
//                }
//
//                // second part
//                if userSecond != correctSecond {
//                    // red
//                    returnString.append(NSAttributedString(string: userSecond, attributes: [NSAttributedStringKey.foregroundColor: wrongColor]))
//                }else {
//                    // green
//                    returnString.append(NSAttributedString(string: userSecond, attributes: [NSAttributedStringKey.foregroundColor: rightColor]))
//                }
//            } else {
//
//                // TODO: - Add better error handling if user entered oi, ar, ir, etc as two seperate sounds.
//
//                // for now just color it all red (also in score counting)
//                returnString.append(NSAttributedString(string: userAnswer, attributes: [NSAttributedStringKey.foregroundColor: wrongColor]))
//            }
            
            
            
        } else { // single
            
            returnString.append(NSAttributedString(string: userAnswer, attributes: [NSAttributedStringKey.foregroundColor: wrongColor]))
            
        }
        
        return returnString
    }
    
    func playIpa(_ ipa: String) {
        
//        if examType == ExamType.doubles {
//            
//            if let fileName = doubleSound.fileNameForIpa(ipa) {
//                player.playSoundFromFile(fileName)
//            }
//            
//        } else {
//            
//            if let fileName = singleSound.fileNameForIpa(ipa) {
//                player.playSoundFromFile(fileName)
//            }
//        }
        
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
