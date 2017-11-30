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
    
    static var storedPracticeMode: SoundMode {
        get {
            let isSingle = UserDefaults.standard.bool(forKey: PRACTICE_MODE_IS_SINGLE_KEY)
            if isSingle {return SoundMode.single}
            return SoundMode.double
        }
    }
}
