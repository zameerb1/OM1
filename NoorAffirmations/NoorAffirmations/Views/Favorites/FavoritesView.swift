//
//  FavoritesView.swift
//  NoorAffirmations
//
//  Saved affirmations — soft, minimal list
//

import SwiftUI

struct FavoritesView: View {
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var selectedQuote: Quote?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.noorCream
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
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Favorites")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.noorText)

                Spacer()

                if !favoritesManager.favorites.isEmpty {
                    Text("\(favoritesManager.favorites.count)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Color.noorAccent)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.noorAccentSoft.opacity(0.3))
                        )
                }
            }

            Text("Your saved affirmations")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(Color.noorTextSecondary)
        }
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 24) {
            Image(systemName: "heart.circle")
                .font(.system(size: 64, weight: .thin))
                .foregroundStyle(Color.noorAccentSoft)

            VStack(spacing: 8) {
                Text("No Favorites Yet")
                    .font(.system(size: 22, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.noorText)

                Text("Tap the heart on any affirmation\nto save it here")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundStyle(Color.noorTextSecondary)
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
        text += "— Noor Affirmations"

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
                    .foregroundStyle(Color.noorText)
                    .lineLimit(3)
                    .lineSpacing(4)

                HStack {
                    Text(quote.category.rawValue)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(Color.noorTextSecondary)

                    Spacer()

                    Image(systemName: quote.category.icon)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.noorAccent)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.noorText.opacity(0.04), radius: 8, x: 0, y: 4)
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
            LinearGradient.backgroundForCategory(quote.category)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                // Handle bar
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color.noorTextTertiary)
                    .frame(width: 40, height: 5)
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
                        VStack(spacing: 8) {
                            Image(systemName: "heart.slash")
                                .font(.system(size: 22))
                            Text("Remove")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundStyle(Color.noorText.opacity(0.6))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.6))
                        )
                    }

                    Button {
                        shareQuote()
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 22))
                            Text("Share")
                                .font(.system(size: 12, weight: .medium))
                        }
                        .foregroundStyle(Color.noorText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.noorAccentSoft.opacity(0.4))
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
        text += "— Noor Affirmations"

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
