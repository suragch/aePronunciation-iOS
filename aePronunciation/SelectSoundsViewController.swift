import UIKit
class SelectSoundsViewController: UIViewController, KeyboardDelegate {

    private static let SINGLE = 0
    private static let DOUBLE = 1
    private var somethingWasChanged = false
    
    var previouslySelectedMode = SoundMode.single
    var previouslySelectedKeys = [String]()
    // var previouslySelectedConsonants: [String]?
    var callback : ((SoundMode, [String], [String]) -> Void)?
    
    @IBOutlet weak var singleDoubleSegmentedControl: UISegmentedControl!
    @IBOutlet weak var vowelsLabel: UILabel!
    @IBOutlet weak var consonantsLabel: UILabel!
    @IBOutlet weak var ipaChooserKeyboard: IpaChooserKeyboard!
    @IBOutlet weak var vowelsSwitch: UISwitch!
    @IBOutlet weak var consonantsSwitch: UISwitch!
    
    // MARK:- Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.navigationController?.navigationBar.topItem?.title = "title_activity_learn_double".localized
        
        //self.navigationItem.title = "select_sounds_title".localized
        self.title = "select_sounds_title".localized
        initPreviouslyChosenItems()
        somethingWasChanged = false
    }
    
    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParentViewController {
            if somethingWasChanged {
                let (vowels, consonants) = getSelectedVowelsConsonants()
                callback?(getSoundMode(), vowels, consonants)
            }
        }
    }
    
    // MARK:- Actions
    
    @IBAction func onSingleDoubleChanged(_ sender: UISegmentedControl) {
        let selectedIndex = sender.selectedSegmentIndex
        if selectedIndex == SelectSoundsViewController.SINGLE {
            ipaChooserKeyboard.mode = SoundMode.single
        } else {
            ipaChooserKeyboard.mode = SoundMode.double
        }
        vowelsSwitch.setOn(true, animated: true)
        consonantsSwitch.setOn(true, animated: true)
        let allSounds = Ipa.getAllVowels() + Ipa.getAllConsonants()
        ipaChooserKeyboard.setKeySelectedFor(selectedSounds: allSounds)
        somethingWasChanged = true
    }
    
    @IBAction func vowelsSwitched(_ sender: UISwitch) {
        let isOn = sender.isOn
        ipaChooserKeyboard.setVowels(areSelected: isOn)
        somethingWasChanged = true
    }
    
    @IBAction func consonantsSwitched(_ sender: UISwitch) {
        let isOn = sender.isOn
        ipaChooserKeyboard.setConsonants(areSelected: isOn)
        somethingWasChanged = true
    }
    
    // MARK:- Keyboard Delegate
    
    func keyWasTapped(_ character: String) {
        somethingWasChanged = true
    }
    
    func keyBackspace() {}
    
    // MARK:- Other
    
    private func initPreviouslyChosenItems() {
        ipaChooserKeyboard.mode = previouslySelectedMode
        if previouslySelectedMode == SoundMode.single {
            singleDoubleSegmentedControl.selectedSegmentIndex = 0
        } else {
            singleDoubleSegmentedControl.selectedSegmentIndex = 1
        }
        //let vowels = previouslySelectedVowels ?? Ipa.getAllVowels()
        //let consonants = previouslySelectedConsonants ?? Ipa.getAllConsonants()
        //let previouslySelected = previouslySelected
        ipaChooserKeyboard.setKeySelectedFor(selectedSounds: previouslySelectedKeys)
        if !ipaChooserKeyboard.hasSelectedVowels() {
            vowelsSwitch.setOn(false, animated: false)
        }
        if !ipaChooserKeyboard.hasSelectedConsonants() {
            consonantsSwitch.setOn(false, animated: false)
        }
    }
        
    private func getSoundMode() -> SoundMode {
        if singleDoubleSegmentedControl.selectedSegmentIndex == SelectSoundsViewController.SINGLE {
            return SoundMode.single
        } else {
            return SoundMode.double
        }
    }
    
    private func getSelectedVowelsConsonants() -> ([String], [String]) {
        return ipaChooserKeyboard.getSelectedVowelsConsonants()
    }
}
