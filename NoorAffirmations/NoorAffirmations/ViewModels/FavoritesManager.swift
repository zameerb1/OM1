//
//  FavoritesManager.swift
//  NoorAffirmations
//

import SwiftUI

@MainActor
class FavoritesManager: ObservableObject {
    @Published var favorites: [Quote] = []

    private let favoritesKey = "savedFavorites"

    init() {
        loadFavorites()
    }

    func isFavorite(_ quote: Quote) -> Bool {
        favorites.contains { $0.id == quote.id }
    }

    func toggleFavorite(_ quote: Quote) {
        if isFavorite(quote) {
            removeFavorite(quote)
        } else {
            addFavorite(quote)
        }
    }

    func addFavorite(_ quote: Quote) {
        guard !isFavorite(quote) else { return }
        favorites.insert(quote, at: 0)
        saveFavorites()
    }

    func removeFavorite(_ quote: Quote) {
        favorites.removeAll { $0.id == quote.id }
        saveFavorites()
    }

    private func saveFavorites() {
        do {
            let encoded = try JSONEncoder().encode(favorites)
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        } catch {
            print("Failed to save favorites: \(error)")
        }
    }

    private func loadFavorites() {
        guard let data = UserDefaults.standard.data(forKey: favoritesKey) else { return }
        do {
            favorites = try JSONDecoder().decode([Quote].self, from: data)
        } catch {
            print("Failed to load favorites: \(error)")
        }
    }
}
