//
//  Quote.swift
//  NoorAffirmations
//

import Foundation

struct Quote: Identifiable, Codable, Equatable {
    let id: UUID
    let textArabic: String?
    let textEnglish: String
    let source: String
    let category: QuoteCategory
    let reference: String?

    init(
        id: UUID = UUID(),
        textArabic: String? = nil,
        textEnglish: String,
        source: String,
        category: QuoteCategory,
        reference: String? = nil
    ) {
        self.id = id
        self.textArabic = textArabic
        self.textEnglish = textEnglish
        self.source = source
        self.category = category
        self.reference = reference
    }
}

enum QuoteCategory: String, Codable, CaseIterable, Identifiable {
    case patience = "Sabr (Patience)"
    case gratitude = "Shukr (Gratitude)"
    case faith = "Iman (Faith)"
    case trust = "Tawakkul (Trust in Allah)"
    case peace = "Salam (Peace)"
    case hope = "Raja (Hope)"
    case mercy = "Rahma (Mercy)"
    case strength = "Quwwa (Strength)"
    case wisdom = "Hikma (Wisdom)"
    case love = "Hubb (Love)"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .patience: return "hourglass"
        case .gratitude: return "hands.clap"
        case .faith: return "star.fill"
        case .trust: return "heart.circle"
        case .peace: return "leaf.fill"
        case .hope: return "sun.max.fill"
        case .mercy: return "drop.fill"
        case .strength: return "bolt.fill"
        case .wisdom: return "book.fill"
        case .love: return "heart.fill"
        }
    }

    var gradientColors: [String] {
        switch self {
        case .patience: return ["#1A535C", "#4ECDC4"]
        case .gratitude: return ["#C9A227", "#F4D03F"]
        case .faith: return ["#2E4057", "#048A81"]
        case .trust: return ["#5B5EA6", "#9B59B6"]
        case .peace: return ["#16A085", "#1ABC9C"]
        case .hope: return ["#F39C12", "#F1C40F"]
        case .mercy: return ["#3498DB", "#5DADE2"]
        case .strength: return ["#8E44AD", "#9B59B6"]
        case .wisdom: return ["#1A535C", "#4ECDC4"]
        case .love: return ["#E74C3C", "#F1948A"]
        }
    }

    var description: String {
        switch self {
        case .patience:
            return "Patience is half of faith. Find peace in waiting."
        case .gratitude:
            return "Gratitude increases blessings. Be thankful always."
        case .faith:
            return "Strengthen your connection with the Divine."
        case .trust:
            return "Place your trust in Allah's plan for you."
        case .peace:
            return "Find tranquility in remembrance of Allah."
        case .hope:
            return "Never despair of Allah's mercy and grace."
        case .mercy:
            return "Show mercy to others as Allah shows mercy to you."
        case .strength:
            return "Draw strength from your faith in difficult times."
        case .wisdom:
            return "Seek knowledge and wisdom in all things."
        case .love:
            return "Love for the sake of Allah brings the purest joy."
        }
    }
}
