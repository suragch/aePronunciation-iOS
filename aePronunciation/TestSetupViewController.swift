import UIKit

enum ExamType: Int {
    case Doubles = 0
    case Singles
    case VowelsOnly
    case ConsonantsOnly
}

class TestSetupViewController: UIViewController, UITextFieldDelegate {

    private var numberOfQuestions = 50 // defaults are registered in AppDelegate
    private let numberOfQuestionsArray = [ 5, 10, 25, 50, 100 ]
    private var contentType = ExamType.Doubles
    private var name = ""
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberOfQuestionsButton: UIButton!
    @IBOutlet weak var contentTypeButton: UIButton!
    
    // MARK: - Actions
    
    @IBAction func numberOfQuestionsButtonTapped(sender: UIButton) {
        
        // Create the action sheet
        let myActionSheet = UIAlertController(title: "Number of Questions", message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        //var alertActions = [ UIAlertAction ]()
        
        for number in numberOfQuestionsArray {
            
            let myAction = UIAlertAction(title: String(number), style: UIAlertActionStyle.Default) { (action) in
                //print("\(number) action button tapped")
                self.numberOfQuestions = number
                self.updateNumberOfQuestionsDisplay()
                
            }
            myActionSheet.addAction(myAction)
        }
        
        
        // cancel action button
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) in
            // do nothing
        }
        myActionSheet.addAction(cancelAction)
        
        // support iPads (popover view)
        myActionSheet.popoverPresentationController?.sourceView = self.numberOfQuestionsButton
        myActionSheet.popoverPresentationController?.sourceRect = self.numberOfQuestionsButton.bounds
        
        // present the action sheet
        self.presentViewController(myActionSheet, animated: true, completion: nil)
        
    }
    
    @IBAction func contentTypeButtonTapped(sender: UIButton) {
        
        // Create the action sheet
        let myActionSheet = UIAlertController(title: "Content", message: "What do you want to take a test on?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        // Double Sounds action button
        let doubleAction = UIAlertAction(title: "Double Sounds (Consonant and Vowel)", style: UIAlertActionStyle.Default) { (action) in
            self.contentType = ExamType.Doubles
            self.updateTypeButtonDisplay()
        }
        
        // Single Sounds action button
        let singleAction = UIAlertAction(title: "Single Sounds (Consonant or Vowel)", style: UIAlertActionStyle.Default) { (action) in
            self.contentType = ExamType.Singles
            self.updateTypeButtonDisplay()
        }
        
        // Vowels Only action button
        let vowelsAction = UIAlertAction(title: "Vowels Only", style: UIAlertActionStyle.Default) { (action) in
            self.contentType = ExamType.VowelsOnly
            self.updateTypeButtonDisplay()
        }
        
        // Consonants Only action button
        let consonantsAction = UIAlertAction(title: "Consonants Only", style: UIAlertActionStyle.Default) { (action) in
            self.contentType = ExamType.ConsonantsOnly
            self.updateTypeButtonDisplay()
        }
        
        // cancel action button
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) in
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
        self.presentViewController(myActionSheet, animated: true, completion: nil)
    }
    
    @IBAction func beginButtonTapped(sender: UIButton) {
        
        // save settings as defaults
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setObject(nameTextField.text, forKey: Key.name)
        userDefaults.setInteger(numberOfQuestions, forKey: Key.numberOfQuestions)
        userDefaults.setInteger(contentType.rawValue, forKey: Key.contentType)
        
    }
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // get defaults from settings
        
        // name
        let userDefaults = NSUserDefaults.standardUserDefaults()
        if let savedName = userDefaults.stringForKey(Key.name) {
            name = savedName
        }
        // number of questions
        let number = userDefaults.integerForKey(Key.numberOfQuestions)
        if number > 0 {
            numberOfQuestions = number
        }
        // content type
        if let type = ExamType(rawValue: userDefaults.integerForKey(Key.contentType)) {
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
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Called when the user click on the view (outside the UITextField).
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Other methods
    
    func updateNumberOfQuestionsDisplay() {
        
        self.numberOfQuestionsButton.setTitle("\(numberOfQuestions) questions", forState: UIControlState.Normal)
    }
    
    func updateTypeButtonDisplay() {
        
        switch contentType {
        case ExamType.Doubles:
            self.contentTypeButton.setTitle("Double Sounds", forState: UIControlState.Normal)
        case ExamType.Singles:
            self.contentTypeButton.setTitle("Single Sounds", forState: UIControlState.Normal)
        case ExamType.VowelsOnly:
            self.contentTypeButton.setTitle("Vowels Only", forState: UIControlState.Normal)
        case ExamType.ConsonantsOnly:
            self.contentTypeButton.setTitle("Consonants Only", forState: UIControlState.Normal)
        }
        
    }
}
