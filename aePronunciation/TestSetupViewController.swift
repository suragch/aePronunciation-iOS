import UIKit

class TestSetupViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberOfQuestionsLabel: UILabel!
    @IBOutlet weak var numberOfQuestionsSegControl: UISegmentedControl!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var typeSegControl: UISegmentedControl!
    @IBOutlet weak var beginButton: UIButton!
        
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.topItem?.title = "app_name".localized
        
        setLocalizedStrings()
        
        //numberOfQuestionsSegControl.superview?.clipsToBounds = true
        
        // localize labels
        
        
        // update display with saved/default values
        let (name, number, mode) = MyUserDefaults.getTestSetupPreferences()
        nameTextField.text = name
        updateNumberOfQuestionsDisplay(number: number)
        updateTypeButtonDisplay(mode: mode)
        
        // set textfield delegate
        nameTextField.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let testVC = segue.destination as? TestViewController {
            
            // save settings as defaults
            let name = getName()
            let number = getSelectedNumberOfQuestions()
            let mode = getSelectedMode()
            MyUserDefaults.saveTestSetupPreferences(
                name: name, number: number, mode: mode)
            
            testVC.userName = name
            testVC.totalNumberOfQuestions = number
            testVC.testMode = mode
        }
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
    
    private func setLocalizedStrings() {
        self.title = "main_tab_test".localized
        nameTextField.placeholder = "test_setup_name".localized
        numberOfQuestionsLabel.text = "test_setup_number_of_questions".localized
        typeLabel.text = "test_setup_type".localized
        typeSegControl.setTitle("test_setup_single".localized, forSegmentAt: 0)
        typeSegControl.setTitle("test_setup_double".localized, forSegmentAt: 1)
        beginButton.setTitle("test_setup_begin_button".localized, for: .normal) 
    }
    
    func updateNumberOfQuestionsDisplay(number: Int) {
        switch number {
        case 5:
            numberOfQuestionsSegControl.selectedSegmentIndex = 0
        case 10:
            numberOfQuestionsSegControl.selectedSegmentIndex = 1
        case 25:
            numberOfQuestionsSegControl.selectedSegmentIndex = 2
        case 50:
            numberOfQuestionsSegControl.selectedSegmentIndex = 3
        case 100:
            numberOfQuestionsSegControl.selectedSegmentIndex = 4
        default:
            numberOfQuestionsSegControl.selectedSegmentIndex = 3
        }
    }

    func updateTypeButtonDisplay(mode: SoundMode) {
        switch mode {
        case SoundMode.single:
            typeSegControl.selectedSegmentIndex = 0
        case SoundMode.double:
            typeSegControl.selectedSegmentIndex = 1
        }
    }
    
    private func getName() -> String {
        return nameTextField.text ?? "test_default_name".localized
    }
    
    private func getSelectedNumberOfQuestions() -> Int {
        let index = numberOfQuestionsSegControl.selectedSegmentIndex
        guard let text = numberOfQuestionsSegControl.titleForSegment(at: index) else {
            return MyUserDefaults.defaultNumberOfTestQuestions
        }
        guard let number = Int(text) else {
            return MyUserDefaults.defaultNumberOfTestQuestions
        }
        return number
    }
    
    private func getSelectedMode() -> SoundMode {
        let index = typeSegControl.selectedSegmentIndex
        switch index {
        case 0:
            return SoundMode.single
        case 1:
            return SoundMode.double
        default:
            return SoundMode.single
        }
    }
 
}
