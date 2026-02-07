//
//  CategoryDetailView.swift
//  NoorAffirmations
//
//  Paginated view of affirmations within a category
//

import SwiftUI

struct CategoryDetailView: View {
    let category: QuoteCategory
    @EnvironmentObject var quoteManager: QuoteManager
    @EnvironmentObject var favoritesManager: FavoritesManager
    @Environment(\.dismiss) var dismiss

    @State private var currentIndex = 0

    private var quotes: [Quote] {
        QuotesData.quotes(for: category)
    }

    var body: some View {
        ZStack {
            // Soft background with category tint
            LinearGradient(
                colors: [
                    Color.noorBackground,
                    Color(hex: category.gradientColors[0]).opacity(0.2),
                    Color(hex: category.gradientColors[1]).opacity(0.15)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                headerSection
                    .padding(.horizontal, 24)
                    .padding(.top, 8)

                Spacer()

                // Quote card with swipe
                if !quotes.isEmpty {
                    TabView(selection: $currentIndex) {
                        ForEach(Array(quotes.enumerated()), id: \.element.id) { index, quote in
                            QuoteCardView(quote: quote)
                                .padding(.horizontal, 24)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .frame(maxHeight: 500)
                }

                Spacer()

                // Bottom controls
                bottomControls
                    .padding(.horizontal, 24)
                    .padding(.bottom, 40)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 14, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 15, weight: .medium))
                    }
                    .foregroundStyle(Color.noorTextSecondary)
                }
            }
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Image(systemName: category.icon)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(Color.noorAccentWarm)

                        Text(category.rawValue)
                            .font(.system(size: 22, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.noorTextPrimary)
                    }

                    Text(category.subtitle)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(Color.noorTextTertiary)
                }

                Spacer()
            }
        }
    }

    // MARK: - Bottom Controls
    private var bottomControls: some View {
        VStack(spacing: 20) {
            // Progress dots
            if !quotes.isEmpty {
                HStack(spacing: 6) {
                    ForEach(0..<quotes.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex ? Color.noorAccentWarm : Color.noorSand)
                            .frame(width: index == currentIndex ? 8 : 6, height: index == currentIndex ? 8 : 6)
                            .animation(.spring(response: 0.3), value: currentIndex)
                    }
                }
            }

            // Action buttons
            HStack(spacing: 36) {
                // Previous
                Button {
                    withAnimation {
                        if currentIndex > 0 {
                            currentIndex -= 1
                        }
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Color.noorTextSecondary)
                        .frame(width: 48, height: 48)
                        .background(
                            Circle()
                                .fill(Color.noorCardBackground)
                                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
                        )
                }
                .disabled(currentIndex == 0)
                .opacity(currentIndex == 0 ? 0.3 : 1)

                // Favorite
                Button {
                    if !quotes.isEmpty {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            favoritesManager.toggleFavorite(quotes[currentIndex])
                        }
                    }
                } label: {
                    let isFavorite = !quotes.isEmpty && favoritesManager.isFavorite(quotes[currentIndex])
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundStyle(isFavorite ? Color.noorAccentWarm : Color.noorTextSecondary)
                        .frame(width: 56, height: 56)
                        .background(
                            Circle()
                                .fill(Color.noorCardBackground)
                                .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 3)
                        )
                }

                // Next
                Button {
                    withAnimation {
                        if currentIndex < quotes.count - 1 {
                            currentIndex += 1
                        }
                    }
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(Color.noorTextSecondary)
                        .frame(width: 48, height: 48)
                        .background(
                            Circle()
                                .fill(Color.noorCardBackground)
                                .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
                        )
                }
                .disabled(currentIndex == quotes.count - 1)
                .opacity(currentIndex == quotes.count - 1 ? 0.3 : 1)
            }
        }
    }
}

#Preview {
    NavigationStack {
        CategoryDetailView(category: .anxietyAndCalm)
            .environmentObject(QuoteManager())
            .environmentObject(FavoritesManager())
    }
}
