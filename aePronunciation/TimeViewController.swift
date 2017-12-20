import UIKit

class TimeViewController: UIViewController {

    @IBOutlet weak var timeLearningTitle: UILabel!
    @IBOutlet weak var timeLearningSinglesTitle: UILabel!
    @IBOutlet weak var timeLearningDoublesTitle: UILabel!
    @IBOutlet weak var timePracticingTitle: UILabel!
    @IBOutlet weak var timePracticingSinglesTitle: UILabel!
    @IBOutlet weak var timePracticingDoublesTitle: UILabel!
    @IBOutlet weak var timeTestingTitle: UILabel!
    @IBOutlet weak var timeTestingSinglesTitle: UILabel!
    @IBOutlet weak var timeTestingDoublesTitle: UILabel!
    @IBOutlet weak var totalTimeTitle: UILabel!
    
    @IBOutlet weak var timeLearning: UILabel!
    @IBOutlet weak var timeLearningSingles: UILabel!
    @IBOutlet weak var timeLearningDoubles: UILabel!
    @IBOutlet weak var timePracticing: UILabel!
    @IBOutlet weak var timePracticingSingles: UILabel!
    @IBOutlet weak var timePracticingDoubles: UILabel!
    @IBOutlet weak var timeTesting: UILabel!
    @IBOutlet weak var timeTestingSingles: UILabel!
    @IBOutlet weak var timeTestingDoubles: UILabel!
    @IBOutlet weak var totalTime: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeLearningTitle.text = "history_time_details_learning".localized
        timeLearningSinglesTitle.text = "history_time_details_type_single".localized
        timeLearningDoublesTitle.text = "history_time_details_type_double".localized
        timePracticingTitle.text = "history_time_details_practicing".localized
        timePracticingSinglesTitle.text = "history_time_details_type_single".localized
        timePracticingDoublesTitle.text = "history_time_details_type_double".localized
        timeTestingTitle.text = "history_time_details_testing".localized
        timeTestingSinglesTitle.text = "history_time_details_type_single".localized
        timeTestingDoublesTitle.text = "history_time_details_type_double".localized
        totalTimeTitle.text = "history_time_details_total".localized
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let secondsLearnSingle = MyUserDefaults.getSecondsLearningSingles()
        let secondsLearnDouble = MyUserDefaults.getSecondsLearningDoubles()
        let secondsPracticeSingle = MyUserDefaults.getSecondsPracticingSingles()
        let secondsPracticeDouble = MyUserDefaults.getSecondsPracticingDoubles()
        let secondsTestSingle = MyUserDefaults.getSecondsTestingSingles()
        let secondsTestDouble = MyUserDefaults.getSecondsTestingDoubles()
        let totalLearn = secondsLearnSingle + secondsLearnDouble
        let totalPractice = secondsPracticeSingle + secondsPracticeDouble
        let totalTest = secondsTestSingle + secondsTestDouble
        let total = totalLearn + totalPractice + totalTest
        
        timeLearning.text = getFormattedString(seconds: totalLearn)
        timeLearningSingles.text = getFormattedString(seconds: secondsLearnSingle)
        timeLearningDoubles.text = getFormattedString(seconds: secondsLearnDouble)
        timePracticing.text = getFormattedString(seconds: totalPractice)
        timePracticingSingles.text = getFormattedString(seconds: secondsPracticeSingle)
        timePracticingDoubles.text = getFormattedString(seconds: secondsPracticeDouble)
        timeTesting.text = getFormattedString(seconds: totalTest)
        timeTestingSingles.text = getFormattedString(seconds: secondsTestSingle)
        timeTestingDoubles.text = getFormattedString(seconds: secondsTestDouble)
        totalTime.text = getFormattedString(seconds: total)
    }
    
    private func getFormattedString(seconds: Int) -> String {
        let (hours, minutes, seconds) = secondsToHoursMinutesSeconds(seconds: seconds)
        var minuteString = "\(minutes)"
        if minutes < 10 {
            minuteString = "0\(minutes)"
        }
        var secondsString = "\(seconds)"
        if seconds < 10 {
            secondsString = "0\(seconds)"
        }
        return "\(hours):\(minuteString):\(secondsString)"
    }
    
    private func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }

}
