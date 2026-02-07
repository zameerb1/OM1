//
//  Color+Extensions.swift
//  NoorAffirmations
//
//  Soft pastel palette inspired by the Glow app aesthetic
//

import SwiftUI

extension Color {
    // Primary palette — warm, calming pastels
    static let noorSage = Color(hex: "#B8C6A8")
    static let noorLavender = Color(hex: "#C4B5D4")
    static let noorSand = Color(hex: "#E8D5B7")
    static let noorRose = Color(hex: "#D4B5B5")
    static let noorSkyBlue = Color(hex: "#B5C9D4")
    static let noorIndigo = Color(hex: "#A8A8C6")

    // Background tones
    static let noorCream = Color(hex: "#FBF8F3")
    static let noorWarmWhite = Color(hex: "#F8F5F0")
    static let noorSoftGray = Color(hex: "#F0EDE8")

    // Text colors
    static let noorText = Color(hex: "#3D3832")
    static let noorTextSecondary = Color(hex: "#8A8279")
    static let noorTextTertiary = Color(hex: "#B5AFA8")

    // Accent
    static let noorAccent = Color(hex: "#C4A882")
    static let noorAccentSoft = Color(hex: "#D9C9AD")

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

// MARK: - Gradient Presets
extension LinearGradient {
    static let noorDefault = LinearGradient(
        colors: [Color(hex: "#F5F0E8"), Color(hex: "#E8E0D5")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let noorBackground = LinearGradient(
        colors: [Color.noorCream, Color.noorWarmWhite],
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

    static func backgroundForCategory(_ category: QuoteCategory) -> LinearGradient {
        LinearGradient(
            colors: category.backgroundColors.map { Color(hex: $0) },
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}
