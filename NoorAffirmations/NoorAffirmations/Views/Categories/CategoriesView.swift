//
//  CategoriesView.swift
//  NoorAffirmations
//
//  Soft grid of affirmation categories
//

import SwiftUI

struct CategoriesView: View {
    @EnvironmentObject var quoteManager: QuoteManager
    @State private var selectedCategory: QuoteCategory?

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.noorBackground
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 24) {
                        // Header
                        headerSection
                            .padding(.horizontal, 24)
                            .padding(.top, 16)

                        // Categories Grid
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(QuoteCategory.allCases) { category in
                                CategoryCard(category: category)
                                    .onTapGesture {
                                        selectedCategory = category
                                    }
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 140)
                    }
                }
            }
            .navigationDestination(item: $selectedCategory) { category in
                CategoryDetailView(category: category)
            }
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Categories")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Color.noorTextPrimary)

            Text("Explore affirmations by theme")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(Color.noorTextTertiary)
        }
    }
}

// MARK: - Category Card
struct CategoryCard: View {
    let category: QuoteCategory
    @State private var isPressed = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.5))
                    .frame(width: 44, height: 44)

                Image(systemName: category.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color.noorTextPrimary.opacity(0.7))
            }

            // Title
            Text(category.rawValue)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(Color.noorTextPrimary)
                .lineLimit(2)
                .minimumScaleFactor(0.8)

            // Subtitle
            Text(category.subtitle)
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(Color.noorTextSecondary)
                .lineLimit(2)

            Spacer(minLength: 0)

            // Quote count
            let count = QuotesData.quotes(for: category).count
            Text("\(count) affirmations")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(Color.noorTextTertiary)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 190)
        .background(
            ZStack {
                LinearGradient.forCategory(category)
                    .opacity(0.4)

                Color.noorCardBackground.opacity(0.5)

                // Decorative circle
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 80, height: 80)
                    .offset(x: 50, y: -25)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 4)
        .scaleEffect(isPressed ? 0.96 : 1)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .onLongPressGesture(minimumDuration: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

#Preview {
    CategoriesView()
        .environmentObject(QuoteManager())
}
