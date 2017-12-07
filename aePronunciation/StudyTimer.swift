import Foundation

class StudyTimer {
    
    // singleton
    static let sharedInstance = StudyTimer()
    private init() {}
    
    private var startTime: Date?
    private var studyType: StudyType?
    enum StudyType {
        case learnSingle
        case learnDouble
        case practiceSingle
        case practiceDouble
        case testSingle
        case testDouble
    }
    
    func start(type: StudyType) {
        
        // no need to restart the timer for the same type
        if self.studyType == type {
            return
        }
        
        // stop and record time for previous type (if any)
        stop()
        
        // start time for this type
        self.startTime = Date()
        self.studyType = type
    }
    
    func stop() {
        guard let currentType = self.studyType else {return}
        guard let start = self.startTime else {return}
        let elapsedTime = abs(start.timeIntervalSinceNow)
        MyUserDefaults.addTime(for: currentType, time: elapsedTime)
        
        // set to nil so that not saving multiple times
        self.studyType = nil
        self.startTime = nil
    }
}
