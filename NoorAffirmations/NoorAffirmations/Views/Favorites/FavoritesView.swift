//
//  FavoritesView.swift
//  NoorAffirmations
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var selectedQuote: Quote?

    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                backgroundGradient
                    .ignoresSafeArea()

                if favoritesManager.favorites.isEmpty {
                    emptyState
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {
                            // Header
                            headerSection
                                .padding(.horizontal, 24)
                                .padding(.top, 16)

                            // Favorites list
                            LazyVStack(spacing: 16) {
                                ForEach(favoritesManager.favorites) { quote in
                                    FavoriteQuoteRow(quote: quote)
                                        .onTapGesture {
                                            selectedQuote = quote
                                        }
                                        .contextMenu {
                                            Button(role: .destructive) {
                                                withAnimation {
                                                    favoritesManager.removeFavorite(quote)
                                                }
                                            } label: {
                                                Label("Remove from Favorites", systemImage: "heart.slash")
                                            }

                                            Button {
                                                shareQuote(quote)
                                            } label: {
                                                Label("Share", systemImage: "square.and.arrow.up")
                                            }
                                        }
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 140)
                        }
                    }
                }
            }
            .sheet(item: $selectedQuote) { quote in
                QuoteDetailSheet(quote: quote)
                    .environmentObject(favoritesManager)
                    .environmentObject(settingsManager)
            }
        }
    }

    // MARK: - Background
    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color(hex: "#0D1B2A"),
                Color(hex: "#1B3A4B"),
                Color(hex: "#274653")
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - Header
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Favorites")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Spacer()

                if !favoritesManager.favorites.isEmpty {
                    Text("\(favoritesManager.favorites.count)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.accentGold.opacity(0.3))
                        )
                }
            }

            Text("Your saved affirmations")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.white.opacity(0.6))
        }
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 24) {
            Image(systemName: "heart.circle")
                .font(.system(size: 80, weight: .light))
                .foregroundStyle(Color.accentGold.opacity(0.5))

            VStack(spacing: 8) {
                Text("No Favorites Yet")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text("Tap the heart icon on any quote to save it here")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(.white.opacity(0.6))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
            }
        }
    }

    // MARK: - Share
    private func shareQuote(_ quote: Quote) {
        var text = "\"\(quote.textEnglish)\"\n\n"
        if let arabic = quote.textArabic {
            text += "\(arabic)\n\n"
        }
        text += "— \(quote.source)"
        if let reference = quote.reference {
            text += " (\(reference))"
        }

        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

// MARK: - Favorite Quote Row
struct FavoriteQuoteRow: View {
    let quote: Quote

    var body: some View {
        HStack(spacing: 16) {
            // Category indicator
            RoundedRectangle(cornerRadius: 4)
                .fill(LinearGradient.forCategory(quote.category))
                .frame(width: 4)

            VStack(alignment: .leading, spacing: 8) {
                Text(quote.textEnglish)
                    .font(.system(size: 15, weight: .regular, design: .serif))
                    .foregroundStyle(.white)
                    .lineLimit(3)
                    .lineSpacing(4)

                HStack {
                    Text(quote.source)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color.accentGold)

                    if let reference = quote.reference {
                        Text("•")
                            .foregroundStyle(.white.opacity(0.4))
                        Text(reference)
                            .font(.system(size: 11, weight: .regular))
                            .foregroundStyle(.white.opacity(0.5))
                    }

                    Spacer()

                    Image(systemName: quote.category.icon)
                        .font(.system(size: 12))
                        .foregroundStyle(.white.opacity(0.4))
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.white.opacity(0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .strokeBorder(.white.opacity(0.1), lineWidth: 1)
                )
        )
    }
}

// MARK: - Quote Detail Sheet
struct QuoteDetailSheet: View {
    let quote: Quote
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            // Background
            LinearGradient.forCategory(quote.category)
                .ignoresSafeArea()

            Color.black.opacity(0.3)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // Handle bar
                RoundedRectangle(cornerRadius: 3)
                    .fill(.white.opacity(0.3))
                    .frame(width: 40, height: 5)
                    .padding(.top, 12)

                Spacer()

                // Quote card
                QuoteCardView(
                    quote: quote,
                    showArabic: settingsManager.showArabicText
                )
                .padding(.horizontal, 24)

                Spacer()

                // Actions
                HStack(spacing: 24) {
                    Button {
                        favoritesManager.removeFavorite(quote)
                        dismiss()
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "heart.slash")
                                .font(.system(size: 24))
                            Text("Remove")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundStyle(.white.opacity(0.8))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(.white.opacity(0.1))
                        )
                    }

                    Button {
                        shareQuote()
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 24))
                            Text("Share")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.accentGold.opacity(0.3))
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.hidden)
    }

    private func shareQuote() {
        var text = "\"\(quote.textEnglish)\"\n\n"
        if let arabic = quote.textArabic {
            text += "\(arabic)\n\n"
        }
        text += "— \(quote.source)"
        if let reference = quote.reference {
            text += " (\(reference))"
        }

        let activityVC = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true)
        }
    }
}

#Preview {
    FavoritesView()
        .environmentObject(FavoritesManager())
        .environmentObject(SettingsManager())
}
