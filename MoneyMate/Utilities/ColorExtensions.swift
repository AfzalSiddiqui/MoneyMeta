import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 122, 255)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct CategoryColors {
    static let all: [(name: String, hex: String)] = [
        ("Red", "#FF6B6B"),
        ("Coral", "#FF8A80"),
        ("Orange", "#FFB74D"),
        ("Amber", "#FFD54F"),
        ("Yellow", "#FFEAA7"),
        ("Lime", "#C5E1A5"),
        ("Green", "#81C784"),
        ("Teal", "#4ECDC4"),
        ("Mint", "#98D8C8"),
        ("Sage", "#96CEB4"),
        ("Cyan", "#4DD0E1"),
        ("Sky", "#45B7D1"),
        ("Blue", "#64B5F6"),
        ("Indigo", "#7986CB"),
        ("Purple", "#BA68C8"),
        ("Plum", "#DDA0DD"),
        ("Pink", "#F48FB1"),
        ("Rose", "#EF9A9A"),
        ("Brown", "#A1887F"),
        ("Grey", "#95A5A6")
    ]
}
