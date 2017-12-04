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
    
    func hasSelectedVowels() -> Bool {
        for myView in subviews {
            guard let key = myView as? KeyboardTextKey else {continue}
            if Ipa.isVowel(ipa: key.primaryString) && key.isSelected {
                return true
            }
        }
        return false
    }
    
    func hasSelectedConsonants() -> Bool {
        for myView in subviews {
            guard let key = myView as? KeyboardTextKey else {continue}
            if Ipa.isConsonant(ipa: key.primaryString) && key.isSelected {
                return true
            }
        }
        return false
    }
    
    func setKeySelectedFor(selectedSounds: [String]?) {
        guard let selected = selectedSounds else {return}
        for myView in subviews {
            guard let key = myView as? KeyboardTextKey else {continue}
            var isSelected = false
            innerLoop: for sound in selected {
                if sound == key.primaryString {
                    isSelected = true
                    break innerLoop
                }
            }
            key.isSelected = isSelected
        }
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
