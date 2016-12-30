import UIKit

enum ExamType: Int {
    case doubles = 0
    case singles
    case vowelsOnly
    case consonantsOnly
}

class TestSetupViewController: UIViewController, UITextFieldDelegate {

    fileprivate var numberOfQuestions = 50 // defaults are registered in AppDelegate
    fileprivate let numberOfQuestionsArray = [ 5, 10, 25, 50, 100 ]
    fileprivate var contentType = ExamType.doubles
    fileprivate var name = ""
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberOfQuestionsButton: UIButton!
    @IBOutlet weak var contentTypeButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func numberOfQuestionsButtonTapped(_ sender: UIButton) {
        
        // Create the action sheet
        let myActionSheet = UIAlertController(title: "Number of Questions", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        //var alertActions = [ UIAlertAction ]()
        
        for number in numberOfQuestionsArray {
            
            let myAction = UIAlertAction(title: String(number), style: UIAlertActionStyle.default) { (action) in
                //print("\(number) action button tapped")
                self.numberOfQuestions = number
                self.updateNumberOfQuestionsDisplay()
                
            }
            myActionSheet.addAction(myAction)
        }
        
        
        // cancel action button
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) in
            // do nothing
        }
        myActionSheet.addAction(cancelAction)
        
        // support iPads (popover view)
        myActionSheet.popoverPresentationController?.sourceView = self.numberOfQuestionsButton
        myActionSheet.popoverPresentationController?.sourceRect = self.numberOfQuestionsButton.bounds
        
        // present the action sheet
        self.present(myActionSheet, animated: true, completion: nil)
        
    }
    
    @IBAction func contentTypeButtonTapped(_ sender: UIButton) {
        
        // Create the action sheet
        let myActionSheet = UIAlertController(title: "Content", message: "What do you want to take a test on?", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        // Double Sounds action button
        let doubleAction = UIAlertAction(title: "Double Sounds (Consonant and Vowel)", style: UIAlertActionStyle.default) { (action) in
            self.contentType = ExamType.doubles
            self.updateTypeButtonDisplay()
        }
        
        // Single Sounds action button
        let singleAction = UIAlertAction(title: "Single Sounds (Consonant or Vowel)", style: UIAlertActionStyle.default) { (action) in
            self.contentType = ExamType.singles
            self.updateTypeButtonDisplay()
        }
        
        // Vowels Only action button
        let vowelsAction = UIAlertAction(title: "Vowels Only", style: UIAlertActionStyle.default) { (action) in
            self.contentType = ExamType.vowelsOnly
            self.updateTypeButtonDisplay()
        }
        
        // Consonants Only action button
        let consonantsAction = UIAlertAction(title: "Consonants Only", style: UIAlertActionStyle.default) { (action) in
            self.contentType = ExamType.consonantsOnly
            self.updateTypeButtonDisplay()
        }
        
        // cancel action button
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) in
            // do nothing
        }
        
        // add action buttons to action sheet
        myActionSheet.addAction(doubleAction)
        myActionSheet.addAction(singleAction)
        myActionSheet.addAction(vowelsAction)
        myActionSheet.addAction(consonantsAction)
        myActionSheet.addAction(cancelAction)
        
        // support iPads (popover view)
        myActionSheet.popoverPresentationController?.sourceView = self.contentTypeButton
        myActionSheet.popoverPresentationController?.sourceRect = self.contentTypeButton.bounds
        
        // present the action sheet
        self.present(myActionSheet, animated: true, completion: nil)
    }
    
    @IBAction func beginButtonTapped(_ sender: UIButton) {
        
        // save settings as defaults
        let userDefaults = UserDefaults.standard
        userDefaults.set(nameTextField.text, forKey: Key.name)
        userDefaults.set(numberOfQuestions, forKey: Key.numberOfQuestions)
        userDefaults.set(contentType.rawValue, forKey: Key.contentType)
        
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get defaults from settings
        
        // name
        let userDefaults = UserDefaults.standard
        if let savedName = userDefaults.string(forKey: Key.name) {
            name = savedName
        }
        // number of questions
        let number = userDefaults.integer(forKey: Key.numberOfQuestions)
        if number > 0 {
            numberOfQuestions = number
        }
        // content type
        if let type = ExamType(rawValue: userDefaults.integer(forKey: Key.contentType)) {
            contentType = type
        }
        
        
        // update display with values
        nameTextField.text = name
        updateNumberOfQuestionsDisplay()
        updateTypeButtonDisplay()
        
        // set textfield delegate
        nameTextField.delegate = self
        
    }
    
    // MARK: - UITextFieldDelegate protocol
    
    // Called when 'return' key pressed.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user click on the view (outside the UITextField).
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Other methods
    
    func updateNumberOfQuestionsDisplay() {
        
        self.numberOfQuestionsButton.setTitle("\(numberOfQuestions) questions", for: UIControlState())
    }
    
    func updateTypeButtonDisplay() {
        
        switch contentType {
        case ExamType.doubles:
            self.contentTypeButton.setTitle("Double Sounds", for: UIControlState())
        case ExamType.singles:
            self.contentTypeButton.setTitle("Single Sounds", for: UIControlState())
        case ExamType.vowelsOnly:
            self.contentTypeButton.setTitle("Vowels Only", for: UIControlState())
        case ExamType.consonantsOnly:
            self.contentTypeButton.setTitle("Consonants Only", for: UIControlState())
        }
        
    }
}
