import UIKit

extension UIColor {
    // Primary app color
    static let appPrimary = UIColor(hex: "#89AAC5")
    
    // Lighter/darker variations
    static let appPrimaryLight = UIColor(hex: "#A4BFD4")
    static let appPrimaryDark = UIColor(hex: "#6E8FA6")
    
    // Convenience initializer for hex colors
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }
}
