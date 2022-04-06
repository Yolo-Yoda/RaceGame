import UIKit

public struct CodableColor {
    let color: UIColor
}

public extension UIColor {
    func codable() -> CodableColor {
        return CodableColor(color: self)
    }
    static func colorFromString (_ colorString: String) -> UIColor {
        switch colorString {
        case "white":
            return UIColor.white
        case "red":
            return UIColor.red
        case "yellow":
            return UIColor.yellow
        default:
            return UIColor.clear
        
        }
    }

}

