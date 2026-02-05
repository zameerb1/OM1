//
//  Color+Extensions.swift
//  NoorAffirmations
//

import SwiftUI

extension Color {
    // Islamic-themed colors
    static let accentGold = Color(hex: "#C9A227")
    static let deepTeal = Color(hex: "#1A535C")
    static let softTeal = Color(hex: "#4ECDC4")
    static let islamicGreen = Color(hex: "#16A085")
    static let royalBlue = Color(hex: "#2E4057")
    static let warmGold = Color(hex: "#F4D03F")

    // Background gradients
    static let backgroundDark = Color(hex: "#0D1B2A")
    static let backgroundLight = Color(hex: "#F8F9FA")

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
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

// MARK: - Gradient Presets
extension LinearGradient {
    static let islamicGold = LinearGradient(
        colors: [Color(hex: "#C9A227"), Color(hex: "#F4D03F")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let islamicTeal = LinearGradient(
        colors: [Color(hex: "#1A535C"), Color(hex: "#4ECDC4")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let islamicNight = LinearGradient(
        colors: [Color(hex: "#0D1B2A"), Color(hex: "#1B3A4B")],
        startPoint: .top,
        endPoint: .bottom
    )

    static let islamicDawn = LinearGradient(
        colors: [Color(hex: "#2E4057"), Color(hex: "#048A81")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let peacefulGreen = LinearGradient(
        colors: [Color(hex: "#16A085"), Color(hex: "#1ABC9C")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static func forCategory(_ category: QuoteCategory) -> LinearGradient {
        LinearGradient(
            colors: category.gradientColors.map { Color(hex: $0) },
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
