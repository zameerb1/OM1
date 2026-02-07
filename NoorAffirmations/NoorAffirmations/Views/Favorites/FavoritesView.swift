//
//  FavoritesView.swift
//  NoorAffirmations
//
//  Saved affirmations with soft, minimal list design
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var selectedQuote: Quote?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.noorBackground
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
                            LazyVStack(spacing: 12) {
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
            }
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("Favorites")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.noorTextPrimary)

                Spacer()

                if !favoritesManager.favorites.isEmpty {
                    Text("\(favoritesManager.favorites.count)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.noorAccentWarm)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 5)
                        .background(
                            Capsule()
                                .fill(Color.noorAccentWarm.opacity(0.12))
                        )
                }
            }

            Text("Your saved affirmations")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(Color.noorTextTertiary)
        }
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "heart")
                .font(.system(size: 56, weight: .ultraLight))
                .foregroundStyle(Color.noorAccentWarm.opacity(0.4))

            VStack(spacing: 8) {
                Text("No Favorites Yet")
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.noorTextPrimary)

                Text("Tap the heart on any affirmation\nto save it here")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color.noorTextTertiary)
                    .multilineTextAlignment(.center)
            }
        }
    }

    // MARK: - Share
    private func shareQuote(_ quote: Quote) {
        var text = "\"\(quote.text)\"\n\n"
        if let inspiration = quote.inspiration {
            text += "\(inspiration)\n\n"
        }
        text += "Shared from Noor — Islamic Affirmations"

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
        HStack(spacing: 14) {
            // Category color indicator
            RoundedRectangle(cornerRadius: 3)
                .fill(LinearGradient.forCategory(quote.category))
                .frame(width: 3)

            VStack(alignment: .leading, spacing: 8) {
                Text(quote.text)
                    .font(.system(size: 15, weight: .regular, design: .serif))
                    .foregroundStyle(Color.noorTextPrimary)
                    .lineLimit(3)
                    .lineSpacing(4)

                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: quote.category.icon)
                            .font(.system(size: 10))
                        Text(quote.category.rawValue)
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundStyle(Color.noorTextTertiary)

                    Spacer()
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.noorCardBackground)
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 3)
        )
    }
}

// MARK: - Quote Detail Sheet
struct QuoteDetailSheet: View {
    let quote: Quote
    @EnvironmentObject var favoritesManager: FavoritesManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            // Soft background
            LinearGradient(
                colors: [
                    Color.noorBackground,
                    Color(hex: quote.category.gradientColors[0]).opacity(0.2),
                    Color(hex: quote.category.gradientColors[1]).opacity(0.15)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 24) {
                // Handle bar
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.noorSand)
                    .frame(width: 40, height: 4)
                    .padding(.top, 12)

                Spacer()

                // Quote card
                QuoteCardView(quote: quote)
                    .padding(.horizontal, 24)

                Spacer()

                // Actions
                HStack(spacing: 16) {
                    Button {
                        favoritesManager.removeFavorite(quote)
                        dismiss()
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: "heart.slash")
                                .font(.system(size: 20))
                            Text("Remove")
                                .font(.system(size: 11, weight: .medium))
                        }
                        .foregroundStyle(Color.noorTextSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.noorSurface)
                        )
                    }

                    Button {
                        shareQuote()
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 20))
                            Text("Share")
                                .font(.system(size: 11, weight: .medium))
                        }
                        .foregroundStyle(Color.noorAccentWarm)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color.noorAccentWarm.opacity(0.1))
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
        var text = "\"\(quote.text)\"\n\n"
        if let inspiration = quote.inspiration {
            text += "\(inspiration)\n\n"
        }
        text += "Shared from Noor — Islamic Affirmations"

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
}
