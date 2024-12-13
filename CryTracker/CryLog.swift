import SwiftUI
import SwiftData

@Model
class CryLog {
    var day: Int
    var month: Int
    var year: Int
    private var colorHex: String // Store color as a hex string
    
    init(day: Int, month: Int, year: Int, color: Color) {
        self.day = day
        self.month = month
        self.year = year
        self.colorHex = CryLog.hexString(from: color)
    }
    
    // Computed property to get/set the Color from hex string
    var color: Color {
        get {
            CryLog.color(from: colorHex) ?? Color.gray
        }
        set {
            colorHex = CryLog.hexString(from: newValue)
        }
    }
    
    // Helper function to convert Color to hex string
    private static func hexString(from color: Color) -> String {
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return String(format: "#%02lX%02lX%02lX", lround(Double(red * 255)), lround(Double(green * 255)), lround(Double(blue * 255)))
    }
    
    // Helper function to convert hex string to Color
    private static func color(from hex: String) -> Color? {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0

        return Color(red: red, green: green, blue: blue)
    }
}
