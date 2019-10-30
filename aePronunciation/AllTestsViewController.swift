import UIKit

class AllTestsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tests: [Test]?
    
    private var currentlySelectedTest: Test?

    let cellReuseIdentifier = "cell"
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateTests()
        
        self.title = "title_activity_history_tests".localized
        // clear the back button item on the test results
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)

        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.backgroundView = refreshControl
        }

        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    @objc func refresh(_ refreshControl: UIRefreshControl) {
        populateTests()
        refreshControl.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let testResultsVC = segue.destination as? TestResultsViewController else {
            return
        }
        guard let test = sender as? Test else {return}
        
        testResultsVC.userName = test.username
        testResultsVC.answers = test.getAnswerArray()
        testResultsVC.timeLength = Int(test.timelength)
        testResultsVC.testMode = test.mode
        testResultsVC.isTestDetails = true
    }
    
    // number of rows in table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tests?.count ?? 0
    }
    
    // create a cell for each table view row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:AllTestsTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as! AllTestsTableViewCell

        guard let myTests = self.tests else {return cell}
        
        let test = myTests[indexPath.row]
        let totalNumber = myTests.count
        cell.testNumber.text = "\(totalNumber - indexPath.row)"
        cell.userName.text = test.username
        cell.score.text = String.localizedStringWithFormat("history_tests_item_score".localized, test.score)
        
        // date
        let date = Date(timeIntervalSince1970: TimeInterval(test.date))
        let formattedDate = AppLocale.getFormattedDate(date: date)
        cell.date.text = formattedDate
        
        // Get the mode (single or double) and the number of questions
        let correctAnswers = test.correctAnswers.split(separator: ",")
        let numberOfQuestions = correctAnswers.count
        let testMode = test.mode
        if testMode == SoundMode.double {
            cell.testType.text = String.localizedStringWithFormat("history_test_details_type_double".localized, numberOfQuestions)
        } else {
            cell.testType.text = String.localizedStringWithFormat("history_test_details_type_single".localized, numberOfQuestions)
        }
        
        return cell
    }
    
    // method to run when table view cell is tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let myTests = self.tests else {
            self.currentlySelectedTest = nil
            return
        }
        let test = myTests[indexPath.row]
        self.performSegue(withIdentifier: "testDetailsSegue", sender: test)

    }

    func populateTests() {
        DispatchQueue.global(qos: .background).async {
            // get tests in the background
            let db = SQLiteDatabase.instance
            let tests = db.getAllTests()
            DispatchQueue.main.async {
                //your main thread
                self.tests = tests
                self.tableView.reloadData()
            }
        }
    }

}
