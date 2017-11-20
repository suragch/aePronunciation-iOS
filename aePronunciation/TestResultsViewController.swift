import UIKit

class TestResultsViewController: UIViewController {

    // values passed in from previous view controller
    var testAnswers = [Answer]()
    var startTime = Date()
    var examType = ExamType.doubles
    
    // constants
    fileprivate let cellReuseIdentifier = "cell"
    fileprivate let rightColor = UIColor(red: 0.031, green: 0.651, blue: 0, alpha: 1) // 08a600 green
    fileprivate let wrongColor = UIColor.red
    fileprivate let endTime = Date()
    //let delayBeforePlayingSecondSound = 1.0
    
    // variables
    fileprivate let player = Player()
    fileprivate lazy var singleSound = SingleSound()
    fileprivate lazy var doubleSound = DoubleSound()
    //var timer = NSTimer()
    
    
    // MARK: - Outlets
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeButton: UIButton!
    @IBOutlet weak var percentLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var wrongLabel: UILabel!
    
    // MARK: - Actions
    
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
        
        // Get name from user defaults
        let userDefaults = UserDefaults.standard
        if let name = userDefaults.string(forKey: Key.name) {
            userNameLabel.text = name
        }
        
        // Set the date
        let now = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // use US English
        formatter.dateStyle = DateFormatter.Style.long
        dateLabel.text = formatter.string(from: now)
        
        // Show elapsed time
        let timeString = getTimeString()
        timeButton.setTitle(timeString, for: UIControlState())
        
        // calculate score
        let numberCorrect = calculateNumberCorrect()
        var totalNumber = testAnswers.count
        if examType == ExamType.doubles {
            totalNumber *= 2
        }
        let score = (numberCorrect * 100) / totalNumber // round down
        percentLabel.text = "\(score)%"
        rightLabel.text = "Right: \(numberCorrect)"
        wrongLabel.text = "Wrong: \(totalNumber - numberCorrect)"
        
        
        
        // register UITableViewCell for reuse
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
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
                
        let correctAnswer = self.testAnswers[indexPath.row].correctAnswer
        let userAnswer = self.testAnswers[indexPath.row].userAnswer
        
        // play sounds
        playIpa(correctAnswer)
        if correctAnswer != userAnswer {
            var delayTime = 1.0
            if correctAnswer == "l" { // this sound needs more time to finish
                delayTime = 2.0
            }
            delay(delayTime) {
                self.playIpa(userAnswer)
            }
        }
    }
    
    // MARK: - Other methods

    func getTimeString() -> String {
        
        var timeString = ""
        
        
        let userCalendar = Calendar.current
        let timeComponents: NSCalendar.Unit = [.hour, .minute, .second]
        let elapsedTime = (userCalendar as NSCalendar).components(
            timeComponents,
            from: startTime,
            to: endTime,
            options: [])
        
        if elapsedTime.hour! > 0 {
            timeString = "\(elapsedTime.hour) hr"
        }
        
        if elapsedTime.minute! > 0 {
            if timeString.characters.count > 0 {
                timeString = timeString + ", "
            }
            timeString = timeString + "\(elapsedTime.minute) min"
        }
        
        if elapsedTime.second! > 0 {
            if timeString.characters.count > 0 {
                timeString = timeString + ", "
            }
            timeString = timeString + "\(elapsedTime.second) sec"
        }
        
        return timeString
    }
    
    func calculateNumberCorrect() -> Int {
    
        // count number correct
        var numCorrect = 0
        for answer in testAnswers {
            
            if examType == ExamType.doubles {
                
                
                let (correctFirst, correctSecond) = doubleSound.parse(answer.correctAnswer)!
                
                if let (userFirst, userSecond) = doubleSound.parse(answer.userAnswer) {
                    if userFirst == correctFirst {
                        numCorrect += 1
                    }
                    if userSecond == correctSecond {
                        numCorrect += 1
                    }
                }
                
                
                
            } else { // single
                if answer.userAnswer == answer.correctAnswer {
                    numCorrect += 1
                }
            }
        }
        
        return numCorrect
    }
    
    func attributedTextForUserAnswer(_ userAnswer: String, correctAnswer: String) -> NSAttributedString {
    
        let returnString = NSMutableAttributedString()
        
        // don't reprint answer if correct
        if userAnswer == correctAnswer {
            return returnString
        }
        
        // color user's wrong answer red
        if examType == ExamType.doubles {
            
            
            let (correctFirst, correctSecond) = doubleSound.parse(correctAnswer)!
            if let (userFirst, userSecond) = doubleSound.parse(userAnswer) {
                
                // first part
                if userFirst != correctFirst {
                    // red
                    returnString.append(NSAttributedString(string: userFirst, attributes: [NSAttributedStringKey.foregroundColor: wrongColor]))
                } else {
                    // green
                    returnString.append(NSAttributedString(string: userFirst, attributes: [NSAttributedStringKey.foregroundColor: rightColor]))
                }
                
                // second part
                if userSecond != correctSecond {
                    // red
                    returnString.append(NSAttributedString(string: userSecond, attributes: [NSAttributedStringKey.foregroundColor: wrongColor]))
                }else {
                    // green
                    returnString.append(NSAttributedString(string: userSecond, attributes: [NSAttributedStringKey.foregroundColor: rightColor]))
                }
            } else {
                
                // TODO: - Add better error handling if user entered oi, ar, ir, etc as two seperate sounds.
                
                // for now just color it all red (also in score counting)
                returnString.append(NSAttributedString(string: userAnswer, attributes: [NSAttributedStringKey.foregroundColor: wrongColor]))
            }
            
            
            
        } else { // single
            
            returnString.append(NSAttributedString(string: userAnswer, attributes: [NSAttributedStringKey.foregroundColor: wrongColor]))
            
        }
        
        return returnString
    }
    
    func playIpa(_ ipa: String) {
        
        if examType == ExamType.doubles {
            
            if let fileName = doubleSound.fileNameForIpa(ipa) {
                player.playSoundFromFile(fileName)
            }
            
        } else {
            
            if let fileName = singleSound.fileNameForIpa(ipa) {
                player.playSoundFromFile(fileName)
            }
        }
        
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
