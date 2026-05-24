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
            (a, r, g, b) = (255, 13, 148, 136)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    static let incomeGreen = Color(hex: "#10B981")
    static let expenseRose = Color(hex: "#F43F5E")
}

struct CategoryColors {
    static let all: [(name: String, hex: String)] = [
        ("Rose", "#FB7185"),
        ("Coral", "#F97316"),
        ("Amber", "#F59E0B"),
        ("Lime", "#84CC16"),
        ("Emerald", "#10B981"),
        ("Teal", "#14B8A6"),
        ("Cyan", "#06B6D4"),
        ("Sky", "#0EA5E9"),
        ("Blue", "#3B82F6"),
        ("Indigo", "#6366F1"),
        ("Violet", "#8B5CF6"),
        ("Purple", "#A855F7"),
        ("Fuchsia", "#D946EF"),
        ("Pink", "#EC4899"),
        ("Peach", "#FCA5A1"),
        ("Mint", "#6EE7B7"),
        ("Sand", "#D4A574"),
        ("Slate", "#64748B"),
        ("Sage", "#94A3B8"),
        ("Stone", "#A8A29E")
    ]
}
