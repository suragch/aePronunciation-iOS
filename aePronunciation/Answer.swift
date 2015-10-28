import Foundation

//enum AnswerType {
//    case Single
//    case Double
//}

class Answer {
    
    //var type = AnswerType.Single
    var correctAnswer = ""
    var userAnswer = ""
    
    init(correctAnswer: String, userAnswer: String) {
        self.correctAnswer = correctAnswer
        self.userAnswer = userAnswer
        //self.type = type
    }
}