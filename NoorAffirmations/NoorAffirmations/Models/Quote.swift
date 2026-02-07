//
//  Quote.swift
//  NoorAffirmations
//
//  Daily Islamic affirmation model
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
    case anxietyCalm = "Anxiety & Calm"
    case trustInAllah = "Trust in Allah"
    case gratitude = "Gratitude"
    case healingHardTimes = "Healing & Hard Times"
    case confidencePurpose = "Confidence & Purpose"
    case nightReflections = "Night Reflections"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .anxietyCalm: return "leaf.fill"
        case .trustInAllah: return "hands.sparkles.fill"
        case .gratitude: return "sun.max.fill"
        case .healingHardTimes: return "heart.circle.fill"
        case .confidencePurpose: return "star.fill"
        case .nightReflections: return "moon.stars.fill"
        }
    }

    var subtitle: String {
        switch self {
        case .anxietyCalm: return "Sakina"
        case .trustInAllah: return "Tawakkul"
        case .gratitude: return "Shukr"
        case .healingHardTimes: return "Sabr"
        case .confidencePurpose: return "Ihsan"
        case .nightReflections: return "Tafakkur"
        }
    }

    var description: String {
        switch self {
        case .anxietyCalm:
            return "Find stillness and peace within"
        case .trustInAllah:
            return "Surrender to the plan already written"
        case .gratitude:
            return "See the blessings woven into your life"
        case .healingHardTimes:
            return "Gentle words for heavy seasons"
        case .confidencePurpose:
            return "Remember who you were created to be"
        case .nightReflections:
            return "Close the day with softness and hope"
        }
    }

    var gradientColors: [String] {
        switch self {
        case .anxietyCalm:
            return ["#B8C6A8", "#D4DFC7"]
        case .trustInAllah:
            return ["#C4B5D4", "#DDD3E8"]
        case .gratitude:
            return ["#E8D5B7", "#F2E6D0"]
        case .healingHardTimes:
            return ["#D4B5B5", "#E8D0D0"]
        case .confidencePurpose:
            return ["#B5C9D4", "#D0DEE8"]
        case .nightReflections:
            return ["#A8A8C6", "#C7C7DF"]
        }
    }

    var backgroundColors: [String] {
        switch self {
        case .anxietyCalm:
            return ["#E8F0E0", "#F5F8F0"]
        case .trustInAllah:
            return ["#EDE7F3", "#F5F0FA"]
        case .gratitude:
            return ["#FDF5E8", "#FEF9F0"]
        case .healingHardTimes:
            return ["#F5E8E8", "#FAF0F0"]
        case .confidencePurpose:
            return ["#E8EFF5", "#F0F5FA"]
        case .nightReflections:
            return ["#E8E8F3", "#F0F0FA"]
        }
    }
}
