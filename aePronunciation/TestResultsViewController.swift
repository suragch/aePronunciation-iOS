import UIKit

class TestResultsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // values passed in from previous view controller
    var userName = "test_default_name".localized
    var timeLength = 0
    var answers = [Answer]()
    var testMode = MyUserDefaults.defaultTestMode
    var isTestDetails = false
    
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
    //@IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var wrongLabel: UILabel!
    @IBOutlet weak var timeLengthLabel: UILabel!
    @IBOutlet weak var practiceDificultButton: UIButton!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backButtonText = "test_results_back_button".localized
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: backButtonText, style: .done, target: self, action: #selector(TestResultsViewController.backButtonTapped))
        
        
        // title
        if isTestDetails {
            self.navigationController?.navigationBar.topItem?.title = "title_activity_history_test_details".localized
        } else {
            self.navigationController?.navigationBar.topItem?.title = "title_activity_test_results".localized
        }
        
        // name
        userNameLabel.text = userName
        
        // date
        let now = Date()
        dateLabel.text = AppLocale.getFormattedDate(date: now)
        
        // calculate score
        let numberCorrect = Test.numberCorrect(inAnswers: answers, testMode: testMode)
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
        timeLengthLabel.text = getTimeString()
        
        // practice button
        // Center button text
        practiceDificultButton.titleLabel?.textAlignment = NSTextAlignment.center
        practiceDificultButton.titleLabel?.numberOfLines = 0
        if score == 100 {
            practiceDificultButton.isHidden = true
        } else {
            practiceDificultButton.setTitle("test_results_practice_difficult_button".localized, for: .normal)
        }
        
        
        // register UITableViewCell for reuse
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        // hide extra lines in table view
        tableView.tableFooterView = UIView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let practiceVC = segue.destination as? PracticeSoundsViewController {
            practiceVC.practiceMode = testMode
            let (vowels, consonants) = findNeedToPracticeSounds()
            practiceVC.selectedVowels = vowels
            practiceVC.selectedConsonants = consonants
        }
    }
    
    // MARK: - Table View methods
    
    // number of rows in table view
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return self.answers.count
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as UITableViewCell!
        
        // make attributes
        let correctAnswer = self.answers[indexPath.row].correctAnswer
        let correctAnswerAttr = NSAttributedString(string: correctAnswer, attributes: [NSAttributedStringKey.foregroundColor: rightColor])
        let userAnswer = self.answers[indexPath.row].userAnswer
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // deselect row after user lifts finger
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
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
    
    @objc func backButtonTapped() {
        if isTestDetails {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
        
    }
    
    func getTimeString() -> String {
        let interval = Int(timeLength)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
    
    private func findNeedToPracticeSounds() -> (vowels: [String], consonants: [String]) {
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
                if parsedCorrect.1 != parsedUser.1 {
                    practiceSet.insert(parsedCorrect.1)
                    practiceSet.insert(parsedUser.1)
                }
            }
        }
        return sortVowelsAndConsonants(sounds: practiceSet)
    }
    
    private func sortVowelsAndConsonants(sounds: Set<String>) -> (vowels: [String], consonants: [String]) {
        
        var vowels = [String]()
        var consonants = [String]()
        
        for sound in sounds {
            if Ipa.isConsonant(ipa: sound) {
                consonants.append(sound)
            } else {
                vowels.append(sound)
            }
        }
        
        return (vowels, consonants)
    }
    
    func attributedTextForUserAnswer(_ userAnswer: String, correctAnswer: String) -> NSAttributedString {
    
        let returnString = NSMutableAttributedString()
        
        // don't reprint answer if correct
        if userAnswer == correctAnswer {
            return returnString
        }
        
        // color user's wrong answer red
        if testMode == SoundMode.double {
            
            let (correctFirst, correctSecond) = DoubleSound.parse(ipaDouble: correctAnswer) ?? ("","")
            if let (userFirst, userSecond) = DoubleSound.parse(ipaDouble: userAnswer) {

                // first part
                if userFirst != correctFirst {
                    // red
                    returnString.append(wrongIpa(userFirst))
                } else {
                    // green
                    returnString.append(rightIpa(userFirst))
                }

                // second part
                if userSecond != correctSecond {
                    // red
                    returnString.append(wrongIpa(userSecond))
                }else {
                    // green
                    returnString.append(rightIpa(userSecond))
                }
            } else {

                // TODO: - Add better error handling if user entered oi, ar, ir, etc as two seperate sounds.

                // for now just color it all red (also in score counting)
                returnString.append(wrongIpa(userAnswer))
            }
            
        } else { // single
            
            returnString.append(NSAttributedString(string: userAnswer, attributes: [NSAttributedStringKey.foregroundColor: wrongColor]))
        }
        
        return returnString
    }
    
    private func wrongIpa(_ ipa: String) -> NSAttributedString {
        return NSAttributedString(string: ipa, attributes: [NSAttributedStringKey.foregroundColor: wrongColor])
    }
    
    private func rightIpa(_ ipa: String) -> NSAttributedString {
        return NSAttributedString(string: ipa, attributes: [NSAttributedStringKey.foregroundColor: rightColor])
    }
    
    func playIpa(_ ipa: String) {
        var fileName: String?
        if testMode == SoundMode.single {
            fileName = SingleSound.getSoundFileName(ipa: ipa)
        } else { // double mode
            fileName = DoubleSound.getSoundFileName(doubleSoundIpa: ipa)
            
            if fileName == nil {Answer.showErrorMessageFor(ipa, in: self)}
        }
        if let name = fileName {
            player.playSoundFrom(file: name)
        }
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
