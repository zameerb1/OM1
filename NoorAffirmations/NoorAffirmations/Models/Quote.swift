//
//  Quote.swift
//  NoorAffirmations
//

import Foundation

struct Quote: Identifiable, Codable, Equatable {
    let id: UUID
    let text: String
    let inspiration: String?
    let category: QuoteCategory

    init(
        id: UUID = UUID(),
        text: String,
        inspiration: String? = nil,
        category: QuoteCategory
    ) {
        self.id = id
        self.text = text
        self.inspiration = inspiration
        self.category = category
    }
}

enum QuoteCategory: String, Codable, CaseIterable, Identifiable {
    case anxietyAndCalm = "Anxiety & Calm"
    case trustInAllah = "Trust in Allah"
    case gratitude = "Gratitude"
    case healingAndHardTimes = "Healing & Hard Times"
    case confidenceAndPurpose = "Confidence & Purpose"
    case nightReflections = "Night Reflections"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .anxietyAndCalm: return "wind"
        case .trustInAllah: return "hands.and.sparkles"
        case .gratitude: return "leaf.fill"
        case .healingAndHardTimes: return "heart.circle"
        case .confidenceAndPurpose: return "sun.max.fill"
        case .nightReflections: return "moon.stars"
        }
    }

    var subtitle: String {
        switch self {
        case .anxietyAndCalm:
            return "Find sakina in moments of worry"
        case .trustInAllah:
            return "Surrender to His perfect plan"
        case .gratitude:
            return "See the blessings all around you"
        case .healingAndHardTimes:
            return "Gentle words for heavy hearts"
        case .confidenceAndPurpose:
            return "You were created with intention"
        case .nightReflections:
            return "Peaceful thoughts before rest"
        }
    }

    var gradientColors: [String] {
        switch self {
        case .anxietyAndCalm: return ["#D4E4D4", "#B7C9B7"]
        case .trustInAllah: return ["#D8CEE8", "#C5B8D9"]
        case .gratitude: return ["#F0D1B8", "#E8C4A8"]
        case .healingAndHardTimes: return ["#F0D8D8", "#E8C4C4"]
        case .confidenceAndPurpose: return ["#F5F0EB", "#E8DDD3"]
        case .nightReflections: return ["#C8DBE8", "#B5CDE0"]
        }
    }

    var description: String {
        subtitle
    }
}
