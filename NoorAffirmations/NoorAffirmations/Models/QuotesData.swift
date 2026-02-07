//
//  QuotesData.swift
//  NoorAffirmations
//
//  First-person Islamic affirmations for daily spiritual well-being
//

import Foundation

struct QuotesData {

    static let allQuotes: [Quote] = [
        // MARK: - Anxiety & Calm (Sakina)
        Quote(
            text: "I breathe in peace, knowing that Allah's plan for me is already perfect.",
            inspiration: "Verily, in the remembrance of Allah do hearts find rest. — 13:28",
            category: .anxietyAndCalm
        ),
        Quote(
            text: "I release my worries to the One who holds the entire universe in balance.",
            category: .anxietyAndCalm
        ),
        Quote(
            text: "I am not alone in this moment. Allah is closer to me than my own heartbeat.",
            inspiration: "We are nearer to him than his jugular vein. — 50:16",
            category: .anxietyAndCalm
        ),
        Quote(
            text: "I choose calm over chaos, because my soul belongs to the Most Peaceful.",
            category: .anxietyAndCalm
        ),
        Quote(
            text: "This feeling will pass. I am safe in the care of Ar-Rahman.",
            category: .anxietyAndCalm
        ),
        Quote(
            text: "I do not need to carry what Allah has not asked me to carry.",
            category: .anxietyAndCalm
        ),
        Quote(
            text: "My anxiety does not define me. I am defined by the One who created me with love.",
            category: .anxietyAndCalm
        ),
        Quote(
            text: "I allow myself to slow down. Stillness is not laziness — it is where I find Allah.",
            category: .anxietyAndCalm
        ),

        // MARK: - Trust in Allah (Tawakkul)
        Quote(
            text: "I trust that Allah is guiding me, even when I cannot see the path.",
            category: .trustInAllah
        ),
        Quote(
            text: "What is written for me will never miss me.",
            category: .trustInAllah
        ),
        Quote(
            text: "I let go of what I cannot control, and I trust the One who controls all things.",
            category: .trustInAllah
        ),
        Quote(
            text: "Allah's timing is not my timing, and that is a mercy I am learning to accept.",
            category: .trustInAllah
        ),
        Quote(
            text: "I tie my camel and place my trust in Allah. I do my part, and He does the rest.",
            inspiration: "Trust in Allah, but tie your camel. — Tirmidhi",
            category: .trustInAllah
        ),
        Quote(
            text: "Every closed door is Allah protecting me from what was not meant for me.",
            category: .trustInAllah
        ),
        Quote(
            text: "I do not need to understand the plan to trust the Planner.",
            category: .trustInAllah
        ),
        Quote(
            text: "When I feel lost, I remember: whoever relies upon Allah, He is sufficient for them.",
            inspiration: "Whoever relies upon Allah — He is sufficient for him. — 65:3",
            category: .trustInAllah
        ),

        // MARK: - Gratitude (Shukr)
        Quote(
            text: "I woke up today, and that alone is a gift I will not take for granted.",
            category: .gratitude
        ),
        Quote(
            text: "I choose to see the blessings, even in the smallest, quietest moments.",
            category: .gratitude
        ),
        Quote(
            text: "My heart overflows with thanks, and I know that gratitude only brings more.",
            inspiration: "If you are grateful, I will surely increase you. — 14:7",
            category: .gratitude
        ),
        Quote(
            text: "I am grateful not because everything is perfect, but because Allah is perfect.",
            category: .gratitude
        ),
        Quote(
            text: "Alhamdulillah for the breath in my lungs and the hope in my heart.",
            category: .gratitude
        ),
        Quote(
            text: "I will not compare my blessings to anyone else's. My rizq is uniquely mine.",
            category: .gratitude
        ),
        Quote(
            text: "Today I notice what I have been overlooking: the warmth of the sun, a kind word, a beating heart.",
            category: .gratitude
        ),

        // MARK: - Healing & Hard Times
        Quote(
            text: "I am allowed to rest. Allah does not burden my soul beyond its capacity.",
            inspiration: "Allah does not burden a soul beyond that it can bear. — 2:286",
            category: .healingAndHardTimes
        ),
        Quote(
            text: "This pain is not permanent. With every hardship comes ease — Allah promised me that.",
            inspiration: "For indeed, with hardship comes ease. — 94:5",
            category: .healingAndHardTimes
        ),
        Quote(
            text: "I am healing at the pace that is right for me. There is no rush in Allah's mercy.",
            category: .healingAndHardTimes
        ),
        Quote(
            text: "My tears are not weakness. Even the Prophet, peace be upon him, wept.",
            category: .healingAndHardTimes
        ),
        Quote(
            text: "I am being shaped by this trial, not broken by it. Allah wastes nothing.",
            category: .healingAndHardTimes
        ),
        Quote(
            text: "I hold on to the belief that what Allah has taken from me, He will replace with something better.",
            category: .healingAndHardTimes
        ),
        Quote(
            text: "I do not need to be strong every moment. I just need to show up and trust.",
            category: .healingAndHardTimes
        ),
        Quote(
            text: "My broken pieces are not lost. Allah is the best of menders.",
            category: .healingAndHardTimes
        ),

        // MARK: - Confidence & Purpose
        Quote(
            text: "My worth is not defined by my productivity, but by my sincerity.",
            category: .confidenceAndPurpose
        ),
        Quote(
            text: "I was created with purpose, placed on this earth at exactly the right time.",
            category: .confidenceAndPurpose
        ),
        Quote(
            text: "I carry the dignity that Allah gave to every child of Adam. No one can take that from me.",
            inspiration: "We have certainly honored the children of Adam. — 17:70",
            category: .confidenceAndPurpose
        ),
        Quote(
            text: "I do not need anyone's approval to feel worthy. Allah already declared me honored.",
            category: .confidenceAndPurpose
        ),
        Quote(
            text: "My voice matters. My existence matters. I am not an accident — I am an ayah.",
            category: .confidenceAndPurpose
        ),
        Quote(
            text: "I will walk through this world gently and confidently, as a servant of the Most High.",
            category: .confidenceAndPurpose
        ),
        Quote(
            text: "I am enough, not because of what I do, but because of who made me.",
            category: .confidenceAndPurpose
        ),
        Quote(
            text: "I choose to show up as my best self today — not perfect, but sincere.",
            category: .confidenceAndPurpose
        ),

        // MARK: - Night Reflections
        Quote(
            text: "I end this day by releasing everything that weighed on me. Tomorrow is a new mercy.",
            category: .nightReflections
        ),
        Quote(
            text: "As the world grows quiet, I remember that Allah never sleeps. I am watched over tonight.",
            inspiration: "Neither drowsiness overtakes Him nor sleep. — 2:255",
            category: .nightReflections
        ),
        Quote(
            text: "I forgive myself for today's shortcomings. Allah's mercy is already waiting for me.",
            category: .nightReflections
        ),
        Quote(
            text: "I close my eyes knowing that whatever I missed today was not meant for me, and whatever I received was a gift.",
            category: .nightReflections
        ),
        Quote(
            text: "Bismillah. I place my soul in Your hands tonight, trusting I will wake renewed.",
            category: .nightReflections
        ),
        Quote(
            text: "The stars above me are a reminder that even in darkness, Allah places light.",
            category: .nightReflections
        ),
        Quote(
            text: "Tonight I am gentle with myself. I did my best, and Allah knows my heart.",
            category: .nightReflections
        ),
        Quote(
            text: "I let go of today's worries, wrapping myself in the peace of the One who created the night for rest.",
            inspiration: "And made the night as clothing. — 78:10",
            category: .nightReflections
        )
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
