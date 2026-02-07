//
//  Color+Extensions.swift
//  NoorAffirmations
//
//  Glow-inspired pastel color palette for calming Islamic affirmations
//

import SwiftUI

extension Color {
    // MARK: - Primary Palette (soft, calming pastels)
    static let noorBeige = Color(hex: "#F5F0EB")
    static let noorSand = Color(hex: "#E8DDD3")
    static let noorSage = Color(hex: "#B7C9B7")
    static let noorLavender = Color(hex: "#C5B8D9")
    static let noorRose = Color(hex: "#E8C4C4")
    static let noorSky = Color(hex: "#B5CDE0")
    static let noorPeach = Color(hex: "#F0D1B8")
    static let noorMist = Color(hex: "#D4DDE6")

    // MARK: - Text Colors
    static let noorTextPrimary = Color(hex: "#3D3D3D")
    static let noorTextSecondary = Color(hex: "#7A7A7A")
    static let noorTextTertiary = Color(hex: "#A8A8A8")

    // MARK: - Accent
    static let noorAccent = Color(hex: "#8B7E74")
    static let noorAccentWarm = Color(hex: "#C4A882")
    static let accentGold = Color(hex: "#C4A882")

    // MARK: - Backgrounds
    static let noorBackground = Color(hex: "#FAF8F5")
    static let noorCardBackground = Color(hex: "#FFFFFF")
    static let noorSurface = Color(hex: "#F2EDE8")

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

// MARK: - Gradient Presets (soft pastels)
extension LinearGradient {
    static let noorWarmSand = LinearGradient(
        colors: [Color(hex: "#F5F0EB"), Color(hex: "#E8DDD3")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let noorGentleSage = LinearGradient(
        colors: [Color(hex: "#D4E4D4"), Color(hex: "#B7C9B7")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let noorSoftLavender = LinearGradient(
        colors: [Color(hex: "#D8CEE8"), Color(hex: "#C5B8D9")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let noorBlush = LinearGradient(
        colors: [Color(hex: "#F0D8D8"), Color(hex: "#E8C4C4")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let noorMorningSky = LinearGradient(
        colors: [Color(hex: "#C8DBE8"), Color(hex: "#B5CDE0")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let noorSunset = LinearGradient(
        colors: [Color(hex: "#F0D1B8"), Color(hex: "#E8C4A8")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let noorDusk = LinearGradient(
        colors: [Color(hex: "#D4DDE6"), Color(hex: "#C0C8D4")],
        startPoint: .top,
        endPoint: .bottom
    )

    static func forCategory(_ category: QuoteCategory) -> LinearGradient {
        LinearGradient(
            colors: category.gradientColors.map { Color(hex: $0) },
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
