import UIKit

extension UIColor {
    class func rgba(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
}

struct Color {
    struct Gray {
        
        /// Red: 230, Green: 230, Blue: 230
        static let Light = UIColor.rgba(230, green: 230, blue: 230, alpha: 1)
        
        /// Red: 200, Green: 200, Blue: 200
        static let Medium = UIColor.rgba(208, green: 208, blue: 208, alpha: 1)
        
        /// Red: 128, Green: 128, Blue: 128
        static let Dark = UIColor.rgba(128, green: 128, blue: 128, alpha: 1)
    }
}