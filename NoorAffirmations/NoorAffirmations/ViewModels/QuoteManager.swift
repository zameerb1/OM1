//
//  QuoteManager.swift
//  NoorAffirmations
//

import SwiftUI
import Combine

@MainActor
class QuoteManager: ObservableObject {
    @Published var currentQuote: Quote
    @Published var todaysQuote: Quote
    @Published var currentCategory: QuoteCategory?
    @Published var categoryQuotes: [Quote] = []

    private var allQuotes: [Quote] = QuotesData.allQuotes

    init() {
        self.currentQuote = QuotesData.dailyQuote
        self.todaysQuote = QuotesData.dailyQuote
    }

    func setCategory(_ category: QuoteCategory) {
        currentCategory = category
        categoryQuotes = QuotesData.quotes(for: category)
        if let first = categoryQuotes.first {
            currentQuote = first
        }
    }

    func clearCategory() {
        currentCategory = nil
        categoryQuotes = []
        currentQuote = todaysQuote
    }

    func nextQuote() {
        if let category = currentCategory {
            currentQuote = QuotesData.randomQuote(from: category)
        } else {
            currentQuote = QuotesData.randomQuote()
        }
    }

    func previousQuote() {
        // For simplicity, just get another random quote
        nextQuote()
    }

    func refreshDailyQuote() {
        todaysQuote = QuotesData.dailyQuote
        if currentCategory == nil {
            currentQuote = todaysQuote
        }
    }

    func getAllQuotes(for category: QuoteCategory) -> [Quote] {
        QuotesData.quotes(for: category)
    }
}
