//
//  NoorAffirmationsApp.swift
//  NoorAffirmations
//
//  Islamic Daily Affirmations App
//

import SwiftUI

@main
struct NoorAffirmationsApp: App {
    @StateObject private var quoteManager = QuoteManager()
    @StateObject private var favoritesManager = FavoritesManager()
    @StateObject private var settingsManager = SettingsManager()

    init() {
        // Request notification permissions on launch
        NotificationService.shared.requestPermission()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(quoteManager)
                .environmentObject(favoritesManager)
                .environmentObject(settingsManager)
                .preferredColorScheme(settingsManager.isDarkMode ? .dark : nil)
        }
    }
}
