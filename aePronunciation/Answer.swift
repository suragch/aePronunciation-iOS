
import UIKit

class Answer {
    
    var correctAnswer = ""
    var userAnswer = ""
    
    init(correctAnswer: String, userAnswer: String) {
        self.correctAnswer = correctAnswer
        self.userAnswer = userAnswer
    }
    
    static func showErrorMessageFor(_ ipa: String, in viewController: UIViewController) {
        
        let errorMessage = Answer.getErrorMessage(doubleIpa: ipa)
        let ok = "error_dialog_ok_button".localized
        
        // create the alert
        let alert = UIAlertController(title: nil, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: ok, style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        viewController.present(alert, animated: true, completion: nil)
    }
    
    private static func getErrorMessage(doubleIpa: String) -> String {
        
        // Types of errors:
        //
        // can't begin with ŋ
        // can't end with w j h
        // r was used as the second sound
        // two vowels
        // two consonants
        
        var errorMessage = ""
        
        let checkParced = DoubleSound.parse(ipaDouble: doubleIpa)
        guard let parsedIpa = checkParced else {
            // TODO return a more intelligent error message (but this situation shouldn't ever happen)
            return errorMessage;
        }
        
        // starts with a consonant
        if "ptkʧfθsʃbdgʤvðzʒmnŋlwjhr".contains(parsedIpa.0) {
            
            // ends with a consonant
            if "ptkʧfθsʃbdgʤvðzʒmnŋlwjhr".contains(parsedIpa.1) {
                
                errorMessage = String.localizedStringWithFormat("error_two_consonants".localized, parsedIpa.0, parsedIpa.1)
                
            } else if (parsedIpa.0 == "ŋ") {
                
                // starts with ŋ
                errorMessage = String.localizedStringWithFormat("error_initial_ng".localized, parsedIpa.0, parsedIpa.1)
                
            }
            
        } else { // starts with a vowel
            
            
            if parsedIpa.1 == "r" {
                
                // ends in r
                errorMessage = "error_final_r".localized
                
            } else if "iɪɛæɑɔʊuʌəeɪaɪaʊɔɪoʊɝɚɑrɛrɪrɔr".contains(parsedIpa.1) {
                
                // ends with vowel
                errorMessage = String.localizedStringWithFormat("error_two_vowels".localized, parsedIpa.0, parsedIpa.1)
                
            } else if "wjh".contains(parsedIpa.1) {
                
                // ends with wjh
                errorMessage = String.localizedStringWithFormat("error_final_wjh".localized, parsedIpa.0, parsedIpa.1)
            }
        }
        
        return errorMessage;
    }
    
    
}
