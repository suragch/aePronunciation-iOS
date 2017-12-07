import UIKit

class MyUserDefaults {
    
    static let TEST_NAME_KEY = "testName"
    static let NUMBER_OF_QUESTIONS_KEY = "numberOfQuestions"
    static let TEST_MODE_KEY = "testMode"
    static let VOWEL_ARRAY_KEY = "vowelArray"
    static let CONSONANT_ARRAY_KEY = "consonantArray"
    static let PRACTICE_MODE_IS_SINGLE_KEY = "practiceMode"
    static let TIME_LEARN_SINGLE_KEY = "timeLearnSingle"
    static let TIME_LEARN_DOUBLE_KEY = "timeLearnDouble"
    static let TIME_PRACTICE_SINGLE_KEY = "timePracticeSingle"
    static let TIME_PRACTICE_DOUBLE_KEY = "timePracticeDouble"
    static let TIME_TEST_SINGLE_KEY = "timeTestSingle"
    static let TIME_TEST_DOUBLE_KEY = "timeTestDouble"
    
    static let defaultNumberOfTestQuestions = 50;
    static let defaultTestMode = SoundMode.single
    private static let defaults = UserDefaults.standard
    
    static var storedPracticeMode: SoundMode {
        get {
            let isSingle = defaults.bool(forKey: PRACTICE_MODE_IS_SINGLE_KEY)
            if isSingle {return SoundMode.single}
            return SoundMode.double
        }
    }
    
    // just to be called one time in the AppDelegate
    class func registerDefaults() {
        //let defaults = UserDefaults.standard
        let defaultValues : [String : Any] = [
            TEST_NAME_KEY : "",
            NUMBER_OF_QUESTIONS_KEY : defaultNumberOfTestQuestions,
            TEST_MODE_KEY : SoundMode.single.rawValue
        ]
        defaults.register(defaults: defaultValues)
    }
    
    class func getTestSetupPreferences()
        -> (name: String, number: Int, mode: SoundMode) {
        
            //let defaults = UserDefaults.standard
            let name = defaults.string(forKey: TEST_NAME_KEY) ?? ""
            let number = defaults.integer(forKey: NUMBER_OF_QUESTIONS_KEY)
            let soundModeRaw = defaults.string(forKey: TEST_MODE_KEY)
            var mode = SoundMode.single
            if soundModeRaw == SoundMode.double.rawValue {
                mode = SoundMode.double
            }
            return (name, number, mode)
    }
    
    class func saveTestSetupPreferences(name: String, number: Int, mode: SoundMode) {
        
        //let defaults = UserDefaults.standard
        defaults.set(name, forKey: TEST_NAME_KEY)
        defaults.set(number, forKey: NUMBER_OF_QUESTIONS_KEY)
        defaults.set(mode.rawValue, forKey: TEST_MODE_KEY)
    }
    
    class func addTime(for currentType: StudyTimer.StudyType, time: TimeInterval) {
        let key: String
        switch currentType {
        case .learnSingle:
            key = TIME_LEARN_SINGLE_KEY
        case .learnDouble:
            key = TIME_LEARN_DOUBLE_KEY
        case .practiceSingle:
            key = TIME_PRACTICE_SINGLE_KEY
        case .practiceDouble:
            key = TIME_PRACTICE_DOUBLE_KEY
        case .testSingle:
            key = TIME_TEST_SINGLE_KEY
        case .testDouble:
            key = TIME_TEST_DOUBLE_KEY
        }
        
        let formerTime = defaults.double(forKey: key)
        let updatedTime = formerTime + time
        defaults.set(updatedTime, forKey: key)
    }
    
}
