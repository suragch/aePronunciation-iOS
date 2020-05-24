
import Foundation

class AppLocale {
    class func getLocale() -> Locale {
        // This allows the date to only be formatted for the translated
        // languages. All others will use the US English format.
        let currentTranslationLocale = "locale".localized
        switch currentTranslationLocale {
        case "zh_Hans":
            return Locale(identifier: "zh_Hans") // Simplified Chinese
        case "zh_Hant":
            return Locale(identifier: "zh_Hant") // Traditional Chinese
        case "ru":
            return Locale(identifier: "ru") // Russian
        case "ja":
            return Locale(identifier: "ja") // Japanese
        case "mn":
            return Locale(identifier: "mn") // Mongolian
        case "vi":
            return Locale(identifier: "vi") // Vietnamese
        default:
            return Locale(identifier: "en_US_POSIX") // US English
        }
    }
    
    class func getFormattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = getLocale()
        formatter.dateStyle = DateFormatter.Style.medium
        formatter.timeStyle = DateFormatter.Style.medium
        return formatter.string(from: date)
        
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/M/d H:mm"
//        return formatter.string(from: date)
    }

}
