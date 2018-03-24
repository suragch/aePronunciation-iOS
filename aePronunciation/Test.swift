
import Foundation

class Test {
    
    let id: Int64?
    var username: String
    var date: Int64
    var timelength: Int64
    var mode: SoundMode
    var score: Int64
    var correctAnswers: String
    var userAnswers: String
    
    init(id: Int64) {
        self.id = id
        self.username = ""
        self.date = 0
        self.timelength = 0
        self.mode = SoundMode.single
        self.score = 0
        self.correctAnswers = ""
        self.userAnswers = ""
    }
    
    init(id: Int64, username: String, date: Int64, timelength: Int64, mode: SoundMode, score: Int64, correctAnswers: String, userAnswers: String) {
        self.id = id
        self.username = username
        self.date = date
        self.timelength = timelength
        self.mode = mode
        self.score = score
        self.correctAnswers = correctAnswers
        self.userAnswers = userAnswers
    }
    
    func getAnswerArray() -> [Answer] {
        var answers = [Answer]()
        let correct = correctAnswers.split(separator: ",")
        let user = userAnswers.split(separator: ",")
        for index in 0..<correct.count {
            let answer = Answer(correctAnswer: String(correct[index]), userAnswer: String(user[index]))
            answers.append(answer)
        }
        return answers
    }
    
    static func numberCorrect(inAnswers answers: [Answer], testMode: SoundMode) -> Int {
        
        // count number correct
        var numCorrect = 0
        for answer in answers {
            let correct = answer.correctAnswer
            let user = answer.userAnswer
            
            // Single
            if testMode == SoundMode.single {
                if correct == user {numCorrect += 1}
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
    
    static func getScorePercent(forAnswers answers: [Answer], testMode: SoundMode) -> Int {
        //let total = answers.count
        let numberCorrect = self.numberCorrect(inAnswers: answers, testMode: testMode)
        var totalNumber = answers.count
        if testMode == SoundMode.double {
            totalNumber *= 2
        }
        let score = (numberCorrect * 100) / totalNumber // round down
        return score
    }
}
