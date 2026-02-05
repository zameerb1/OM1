//
//  CategoryDetailView.swift
//  NoorAffirmations
//

import SwiftUI

struct CategoryDetailView: View {
    let category: QuoteCategory
    @EnvironmentObject var quoteManager: QuoteManager
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var settingsManager: SettingsManager
    @Environment(\.dismiss) var dismiss

    @State private var currentIndex = 0
    @State private var dragOffset: CGFloat = 0

    private var quotes: [Quote] {
        QuotesData.quotes(for: category)
    }

    var body: some View {
        ZStack {
            // Background
            LinearGradient.forCategory(category)
                .ignoresSafeArea()

            // Overlay
            Color.black.opacity(0.3)
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
                            QuoteCardView(
                                quote: quote,
                                showArabic: settingsManager.showArabicText
                            )
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
                            .font(.system(size: 16, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundStyle(.white)
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
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Color.accentGold)

                        Text(category.rawValue)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    }

                    Text(category.description)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(.white.opacity(0.7))
                }

                Spacer()
            }
        }
    }

    // MARK: - Bottom Controls
    private var bottomControls: some View {
        VStack(spacing: 20) {
            // Progress indicator
            if !quotes.isEmpty {
                HStack(spacing: 4) {
                    Text("\(currentIndex + 1)")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(Color.accentGold)

                    Text("of \(quotes.count)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.white.opacity(0.6))
                }
            }

            // Action buttons
            HStack(spacing: 40) {
                // Previous
                Button {
                    withAnimation {
                        if currentIndex > 0 {
                            currentIndex -= 1
                        }
                    }
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 50, height: 50)
                        .background(Circle().fill(.white.opacity(0.15)))
                }
                .disabled(currentIndex == 0)
                .opacity(currentIndex == 0 ? 0.4 : 1)

                // Favorite
                Button {
                    if !quotes.isEmpty {
                        favoritesManager.toggleFavorite(quotes[currentIndex])
                    }
                } label: {
                    let isFavorite = !quotes.isEmpty && favoritesManager.isFavorite(quotes[currentIndex])
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(isFavorite ? Color.accentGold : .white)
                        .frame(width: 60, height: 60)
                        .background(Circle().fill(.white.opacity(0.2)))
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
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 50, height: 50)
                        .background(Circle().fill(.white.opacity(0.15)))
                }
                .disabled(currentIndex == quotes.count - 1)
                .opacity(currentIndex == quotes.count - 1 ? 0.4 : 1)
            }
        }
    }
}

#Preview {
    NavigationStack {
        CategoryDetailView(category: .patience)
            .environmentObject(QuoteManager())
            .environmentObject(FavoritesManager())
            .environmentObject(SettingsManager())
    }
}
