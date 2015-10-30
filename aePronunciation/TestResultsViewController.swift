import UIKit

class TestResultsViewController: UIViewController {

    // values passed in from previous view controller
    var testAnswers = [Answer]()
    var startTime = NSDate()
    var examType = ExamType.Doubles
    
    // constants
    private let cellReuseIdentifier = "cell"
    private let rightColor = UIColor(red: 0.031, green: 0.651, blue: 0, alpha: 1) // 08a600 green
    private let wrongColor = UIColor.redColor()
    private let endTime = NSDate()
    //let delayBeforePlayingSecondSound = 1.0
    
    // variables
    private let player = Player()
    private lazy var singleSound = SingleSound()
    private lazy var doubleSound = DoubleSound()
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
    
    @IBAction func timeButtonTapped(sender: UIButton) {
        
        // get the time strings
        let formatter = NSDateFormatter()
        formatter.timeStyle = NSDateFormatterStyle.MediumStyle
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let startTimeString = formatter.stringFromDate(startTime)
        let endTimeString = formatter.stringFromDate(endTime)
        
        // create the message from the time strings
        let message = "Start time: \(startTimeString)\nEndTime: \(endTimeString)"
        
        // start an alert with start and stop time
        let alert = UIAlertController(title: "Test Time Length", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonTapped(sender: UIBarButtonItem) {
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Get name from user defaults
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let name = userDefaults.stringForKey(Key.name) {
            userNameLabel.text = name
        }
        
        // Set the date
        let now = NSDate()
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") // use US English
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        dateLabel.text = formatter.stringFromDate(now)
        
        // Show elapsed time
        let timeString = getTimeString()
        timeButton.setTitle(timeString, forState: UIControlState.Normal)
        
        // calculate score
        let numberCorrect = calculateNumberCorrect()
        var totalNumber = testAnswers.count
        if examType == ExamType.Doubles {
            totalNumber *= 2
        }
        let score = (numberCorrect * 100) / totalNumber // round down
        percentLabel.text = "\(score)%"
        rightLabel.text = "Right: \(numberCorrect)"
        wrongLabel.text = "Wrong: \(totalNumber - numberCorrect)"
        
        
        
        // register UITableViewCell for reuse
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    // MARK: - Table View methods
    
    // number of rows in table view
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.testAnswers.count
    }
    
    // create a cell for each table view row
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        // make attributes
        let correctAnswer = self.testAnswers[indexPath.row].correctAnswer
        let correctAnswerAttr = NSAttributedString(string: correctAnswer, attributes: [NSForegroundColorAttributeName: rightColor])
        let userAnswer = self.testAnswers[indexPath.row].userAnswer
        let userAnswerAttr = attributedTextForUserAnswer(userAnswer, correctAnswer: correctAnswer)
        
        // build string
        let attributedString = NSMutableAttributedString(string: "\(indexPath.row + 1).  ")
        attributedString.appendAttributedString(correctAnswerAttr)
        attributedString.appendAttributedString(NSAttributedString(string: "  "))
        attributedString.appendAttributedString(userAnswerAttr)
        
        // set label text
        cell.textLabel?.attributedText = attributedString
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
                
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
        
        
        let userCalendar = NSCalendar.currentCalendar()
        let timeComponents: NSCalendarUnit = [.Hour, .Minute, .Second]
        let elapsedTime = userCalendar.components(
            timeComponents,
            fromDate: startTime,
            toDate: endTime,
            options: [])
        
        if elapsedTime.hour > 0 {
            timeString = "\(elapsedTime.hour) hr"
        }
        
        if elapsedTime.minute > 0 {
            if timeString.characters.count > 0 {
                timeString = timeString + ", "
            }
            timeString = timeString + "\(elapsedTime.minute) min"
        }
        
        if elapsedTime.second > 0 {
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
            
            if examType == ExamType.Doubles {
                
                
                let (correctFirst, correctSecond) = doubleSound.parse(answer.correctAnswer)!
                
                if let (userFirst, userSecond) = doubleSound.parse(answer.userAnswer) {
                    if userFirst == correctFirst {
                        numCorrect++
                    }
                    if userSecond == correctSecond {
                        numCorrect++
                    }
                }
                
                
                
            } else { // single
                if answer.userAnswer == answer.correctAnswer {
                    numCorrect++
                }
            }
        }
        
        return numCorrect
    }
    
    func attributedTextForUserAnswer(userAnswer: String, correctAnswer: String) -> NSAttributedString {
    
        let returnString = NSMutableAttributedString()
        
        // don't reprint answer if correct
        if userAnswer == correctAnswer {
            return returnString
        }
        
        // color user's wrong answer red
        if examType == ExamType.Doubles {
            
            
            let (correctFirst, correctSecond) = doubleSound.parse(correctAnswer)!
            if let (userFirst, userSecond) = doubleSound.parse(userAnswer) {
                
                // first part
                if userFirst != correctFirst {
                    // red
                    returnString.appendAttributedString(NSAttributedString(string: userFirst, attributes: [NSForegroundColorAttributeName: wrongColor]))
                } else {
                    // green
                    returnString.appendAttributedString(NSAttributedString(string: userFirst, attributes: [NSForegroundColorAttributeName: rightColor]))
                }
                
                // second part
                if userSecond != correctSecond {
                    // red
                    returnString.appendAttributedString(NSAttributedString(string: userSecond, attributes: [NSForegroundColorAttributeName: wrongColor]))
                }else {
                    // green
                    returnString.appendAttributedString(NSAttributedString(string: userSecond, attributes: [NSForegroundColorAttributeName: rightColor]))
                }
            } else {
                
                // TODO: - Add better error handling if user entered oi, ar, ir, etc as two seperate sounds.
                
                // for now just color it all red (also in score counting)
                returnString.appendAttributedString(NSAttributedString(string: userAnswer, attributes: [NSForegroundColorAttributeName: wrongColor]))
            }
            
            
            
        } else { // single
            
            returnString.appendAttributedString(NSAttributedString(string: userAnswer, attributes: [NSForegroundColorAttributeName: wrongColor]))
            
        }
        
        return returnString
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
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}
