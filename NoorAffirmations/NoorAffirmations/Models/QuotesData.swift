//
//  QuotesData.swift
//  NoorAffirmations
//
//  First-person Islamic affirmations dataset
//

import Foundation

struct QuotesData {

    static let allQuotes: [Quote] = [

        // MARK: - Anxiety & Calm (Sakina)

        Quote(
            text: "I release what I cannot control and place it gently in Allah's hands.",
            category: .anxietyCalm
        ),
        Quote(
            text: "My heart finds rest in the remembrance of Allah. I am safe here.",
            inspiration: "Inspired by Surah Ar-Ra'd 13:28",
            category: .anxietyCalm
        ),
        Quote(
            text: "I breathe in peace. I breathe out worry. Allah is closer to me than I know.",
            category: .anxietyCalm
        ),
        Quote(
            text: "I am not alone in this. The One who created me is holding me through it.",
            category: .anxietyCalm
        ),
        Quote(
            text: "I do not need to carry everything at once. I am allowed to be still.",
            category: .anxietyCalm
        ),
        Quote(
            text: "This anxious moment will pass. Allah's peace is always available to me.",
            category: .anxietyCalm
        ),

        // MARK: - Trust in Allah (Tawakkul)

        Quote(
            text: "I trust that Allah is guiding me, even when I cannot see the path.",
            category: .trustInAllah
        ),
        Quote(
            text: "What is written for me will never miss me. What misses me was never mine.",
            category: .trustInAllah
        ),
        Quote(
            text: "I tie my camel and trust. I do my part, then surrender the rest.",
            inspiration: "Inspired by a hadith in Tirmidhi",
            category: .trustInAllah
        ),
        Quote(
            text: "I do not need to understand the full picture. I trust the Artist.",
            category: .trustInAllah
        ),
        Quote(
            text: "Allah is sufficient for me. There is no power except with Him.",
            inspiration: "Inspired by Surah At-Talaq 65:3",
            category: .trustInAllah
        ),
        Quote(
            text: "I release the need to know why. I choose to trust that it will make sense one day.",
            category: .trustInAllah
        ),

        // MARK: - Gratitude (Shukr)

        Quote(
            text: "I choose to notice the quiet blessings that fill my ordinary days.",
            category: .gratitude
        ),
        Quote(
            text: "Alhamdulillah for this breath, this moment, this chance to begin again.",
            category: .gratitude
        ),
        Quote(
            text: "When I am grateful, more goodness flows into my life. This is Allah's promise.",
            inspiration: "Inspired by Surah Ibrahim 14:7",
            category: .gratitude
        ),
        Quote(
            text: "I am thankful not because everything is perfect, but because I can see beauty in imperfection.",
            category: .gratitude
        ),
        Quote(
            text: "My life is already full of answered prayers that I once thought were impossible.",
            category: .gratitude
        ),
        Quote(
            text: "I thank Allah for the things I cannot see that He protected me from.",
            category: .gratitude
        ),

        // MARK: - Healing & Hard Times (Sabr)

        Quote(
            text: "I am allowed to rest. Allah does not burden my soul beyond its capacity.",
            inspiration: "Inspired by Surah Al-Baqarah 2:286",
            category: .healingHardTimes
        ),
        Quote(
            text: "This hardship is not a punishment. It is a passage, and I will come through it.",
            category: .healingHardTimes
        ),
        Quote(
            text: "After every difficulty comes ease. I hold on to this truth today.",
            inspiration: "Inspired by Surah Ash-Sharh 94:5-6",
            category: .healingHardTimes
        ),
        Quote(
            text: "I am healing at my own pace, and Allah is patient with me.",
            category: .healingHardTimes
        ),
        Quote(
            text: "My tears are not weakness. They are a conversation between my heart and my Lord.",
            category: .healingHardTimes
        ),
        Quote(
            text: "I have survived every hard day so far. Allah did not bring me this far to abandon me.",
            category: .healingHardTimes
        ),

        // MARK: - Confidence & Purpose (Ihsan)

        Quote(
            text: "My worth is not defined by my productivity, but by my sincerity.",
            category: .confidencePurpose
        ),
        Quote(
            text: "I was created with intention. Allah does not make mistakes.",
            category: .confidencePurpose
        ),
        Quote(
            text: "I walk through this world knowing I carry a light that was placed inside me before I was born.",
            category: .confidencePurpose
        ),
        Quote(
            text: "I do not need to be perfect. I need to be honest, sincere, and present.",
            category: .confidencePurpose
        ),
        Quote(
            text: "I am enough, not because of what I do, but because of who created me.",
            category: .confidencePurpose
        ),
        Quote(
            text: "My purpose is not to please everyone. My purpose is to live with ihsan — excellence and sincerity.",
            category: .confidencePurpose
        ),

        // MARK: - Night Reflections (Tafakkur)

        Quote(
            text: "I close this day knowing that whatever I could not finish, Allah will carry for me.",
            category: .nightReflections
        ),
        Quote(
            text: "Tonight I forgive myself for what I could not be today. Tomorrow is mercy renewed.",
            category: .nightReflections
        ),
        Quote(
            text: "As the night wraps around me, I remember: the stars only shine in the dark.",
            category: .nightReflections
        ),
        Quote(
            text: "I end this day with alhamdulillah on my lips and peace in my chest.",
            category: .nightReflections
        ),
        Quote(
            text: "I lay down my worries. The One who governs the night sky governs my life too.",
            category: .nightReflections
        ),
        Quote(
            text: "Sleep is a small trust in Allah — I close my eyes believing I will wake to new mercy.",
            category: .nightReflections
        ),
    ]

    static func quotes(for category: QuoteCategory) -> [Quote] {
        allQuotes.filter { $0.category == category }
    }

    static var dailyQuote: Quote {
        let calendar = Calendar.current
        let dayOfYear = calendar.ordinality(of: .day, in: .year, for: Date()) ?? 1
        let index = (dayOfYear - 1) % allQuotes.count
        return allQuotes[index]
    }

    static func randomQuote() -> Quote {
        allQuotes.randomElement() ?? allQuotes[0]
    }

    static func randomQuote(from category: QuoteCategory) -> Quote {
        let categoryQuotes = quotes(for: category)
        return categoryQuotes.randomElement() ?? allQuotes[0]
    }
}
