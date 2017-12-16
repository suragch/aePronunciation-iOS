
import Foundation
import SQLite

class SQLiteDatabase {
    
    static let instance = SQLiteDatabase()
    private let dbConnection: Connection?
    
    private let tests = Table("tests")
    private let id = Expression<Int64>("id")
    private let username = Expression<String>("name")
    private let date = Expression<Int64>("test_date")
    private let timelength = Expression<Int64>("time_length")
    private let mode = Expression<String>("mode")
    private let score = Expression<Int64>("score")
    private let correctAnswers = Expression<String>("correct")
    private let userAnswers = Expression<String>("user_answer")

    
    private init() {
        let filename = "db.sqlite"
        
        guard let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
            ).first else {
                dbConnection = nil
                print ("Unable to access database path")
                return
        }
        
        do {
            dbConnection = try Connection("\(path)/\(filename)")
        } catch {
            dbConnection = nil
            print ("Unable to open database")
        }
        
        createTable()
    }
    
    func createTable() {
        do {
            try dbConnection!.run(tests.create(ifNotExists: true) { table in
                table.column(id, primaryKey: true)
                table.column(username)
                table.column(date)
                table.column(timelength)
                table.column(mode)
                table.column(score)
                table.column(correctAnswers)
                table.column(userAnswers)
            })
        } catch {
            print("Unable to create table")
        }
    }

    func getAllTests() -> [Test] {
        
        var allTests = [Test]()
        
        guard let db = dbConnection else {return allTests}
        
        do {
            for test in try db.prepare(self.tests).reversed() {
                guard let soundMode = SoundMode(rawValue: test[mode]) else {
                    continue
                }
                allTests.append(Test(
                    id: test[id],
                    username: test[username],
                    date: test[date],
                    timelength: test[timelength],
                    mode: soundMode,
                    score: test[score],
                    correctAnswers: test[correctAnswers],
                    userAnswers: test[userAnswers]))
            }
        } catch {
            print("Select failed")
        }
        
        return allTests
    }

    func getTest(id: Int64) -> Test? {
        guard let db = dbConnection else {return nil}
        let query = tests.filter(self.id == id)
        do {
            let tests = try db.prepare(query)
            for test in tests {
                guard let soundMode = SoundMode(rawValue: test[self.mode]) else {
                    return nil
                }
                return Test(
                    id: test[self.id],
                    username: test[self.username],
                    date: test[self.date],
                    timelength: test[self.timelength],
                    mode: soundMode,
                    score: test[self.score],
                    correctAnswers: test[self.correctAnswers],
                    userAnswers: test[self.userAnswers])
            }
        } catch {
            print("Select failed")
        }
        return nil
    }
    
    func getHighScores() -> (singlesMax: Int, doublesMax: Int) {
        guard let db = dbConnection else {return (0,0)}
        let single = SoundMode.single.rawValue
        let double = SoundMode.double.rawValue
        do {
            let singlesMax = try db.scalar(tests.filter(mode == single).select(score.max)) ?? 0
            let doublesMax = try db.scalar(tests.filter(mode == double).select(score.max)) ?? 0
            return (Int(singlesMax), Int(doublesMax))
        } catch {
            print("Highscore db query failed")
            return (0,0)
        }
    }
    
    func addTest(_ test: Test) -> Int64? {
        guard let db = dbConnection else {return nil}
        
        do {
            let insert = tests.insert(
                username <- test.username,
                date <- test.date,
                timelength <- test.timelength,
                mode <- test.mode.rawValue,
                score <- test.score,
                correctAnswers <- test.correctAnswers,
                userAnswers <- test.userAnswers)
            let id = try db.run(insert)
            return id
        } catch {
            print("Insert failed")
            return -1
        }
    }
}
