import UIKit

class IpaChooserKeyboard: IpaKeyboard {
        
    func getSelectedVowelsConsonants() -> ([String], [String]) {
        var vowels = [String]()
        var consonants = [String]()
        for myView in subviews {
            guard let key = myView as? KeyboardTextKey else {continue}
            if key.isSelected {
                if Ipa.isConsonant(ipa: key.primaryString) {
                    consonants.append(key.primaryString)
                } else {
                    vowels.append(key.primaryString)
                }
            }
        }
        return (vowels, consonants)
    }
    
    override func keyTextEntered(sender: KeyboardKey, keyText: String) {
        sender.isSelected = !sender.isSelected
    }
    
    func setVowels(areSelected: Bool) {
        for myView in subviews {
            guard let key = myView as? KeyboardTextKey else {continue}
            if Ipa.isVowel(ipa: key.primaryString) {
                key.isSelected = areSelected
            }
        }
    }
    
    func setConsonants(areSelected: Bool) {
        for myView in subviews {
            guard let key = myView as? KeyboardTextKey else {continue}
            if Ipa.isConsonant(ipa: key.primaryString) {
                key.isSelected = areSelected
            }
        }
    }
}
