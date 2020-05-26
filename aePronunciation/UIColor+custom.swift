import UIKit

extension UIColor {
    
    class var rightGreen: UIColor {
        return UIColor.rgb(fromHex: 0x249900)
    }
    
    class func rgb(fromHex: Int) -> UIColor {
        
        let red =   CGFloat((fromHex & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((fromHex & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(fromHex & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    class var systemDefaultTextColor: UIColor {
        if #available(iOS 13.0, *) {
            return UIColor.init { (trait) -> UIColor in
                return trait.userInterfaceStyle == .dark ?
                    UIColor.label :
                    UIColor.black
            }
        } else {
            return UIColor.black
        }
    }
}
