import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }

    // App theme colors
    static let appPrimary = Color(hex: "2563EB")
    static let appSecondary = Color(hex: "7C3AED")
    static let appBackground = Color(hex: "F8FAFC")
    static let appCardBackground = Color.white
    static let appTextPrimary = Color(hex: "1E293B")
    static let appTextSecondary = Color(hex: "64748B")

    // Project colors
    static let projectBlue = Color(hex: "3B82F6")
    static let projectGreen = Color(hex: "22C55E")
    static let projectOrange = Color(hex: "F97316")
    static let projectRed = Color(hex: "EF4444")
    static let projectPurple = Color(hex: "A855F7")
    static let projectTeal = Color(hex: "14B8A6")
    static let projectPink = Color(hex: "EC4899")
    static let projectYellow = Color(hex: "EAB308")
}

extension ProjectColor {
    var color: Color {
        switch self {
        case .blue: return .projectBlue
        case .green: return .projectGreen
        case .orange: return .projectOrange
        case .red: return .projectRed
        case .purple: return .projectPurple
        case .teal: return .projectTeal
        case .pink: return .projectPink
        case .yellow: return .projectYellow
        }
    }

    var gradient: LinearGradient {
        switch self {
        case .blue:
            return LinearGradient(colors: [Color(hex: "3B82F6"), Color(hex: "1D4ED8")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .green:
            return LinearGradient(colors: [Color(hex: "22C55E"), Color(hex: "16A34A")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .orange:
            return LinearGradient(colors: [Color(hex: "F97316"), Color(hex: "EA580C")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .red:
            return LinearGradient(colors: [Color(hex: "EF4444"), Color(hex: "DC2626")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .purple:
            return LinearGradient(colors: [Color(hex: "A855F7"), Color(hex: "9333EA")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .teal:
            return LinearGradient(colors: [Color(hex: "14B8A6"), Color(hex: "0D9488")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .pink:
            return LinearGradient(colors: [Color(hex: "EC4899"), Color(hex: "DB2777")], startPoint: .topLeading, endPoint: .bottomTrailing)
        case .yellow:
            return LinearGradient(colors: [Color(hex: "EAB308"), Color(hex: "CA8A04")], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}
