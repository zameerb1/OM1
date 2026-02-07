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
            // Soft background for category
            LinearGradient.backgroundForCategory(category)
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
                    .frame(maxHeight: 480)
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
                            .font(.system(size: 16, weight: .medium))
                        Text("Back")
                            .font(.system(size: 16, weight: .medium))
                    }
                    .foregroundStyle(Color.noorText)
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
                            .foregroundStyle(Color.noorAccent)

                        Text(category.rawValue)
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(Color.noorText)
                    }

                    Text(category.description)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundStyle(Color.noorTextSecondary)
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
                HStack(spacing: 6) {
                    ForEach(0..<quotes.count, id: \.self) { index in
                        Circle()
                            .fill(index == currentIndex ? Color.noorAccent : Color.noorTextTertiary.opacity(0.4))
                            .frame(width: index == currentIndex ? 8 : 6, height: index == currentIndex ? 8 : 6)
                            .animation(.spring(response: 0.3), value: currentIndex)
                    }
                }
            }

            // Action buttons
            HStack(spacing: 36) {
                // Previous
                SoftCircleButton(icon: "chevron.left") {
                    withAnimation {
                        if currentIndex > 0 {
                            currentIndex -= 1
                        }
                    }
                }

                // Favorite
                if !quotes.isEmpty {
                    let isFavorite = favoritesManager.isFavorite(quotes[currentIndex])
                    SoftCircleButton(
                        icon: isFavorite ? "heart.fill" : "heart",
                        isAccent: isFavorite
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            favoritesManager.toggleFavorite(quotes[currentIndex])
                        }
                    }
                }

                // Next
                SoftCircleButton(icon: "chevron.right") {
                    withAnimation {
                        if currentIndex < quotes.count - 1 {
                            currentIndex += 1
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        CategoryDetailView(category: .anxietyCalm)
            .environmentObject(QuoteManager())
            .environmentObject(FavoritesManager())
    }
}
