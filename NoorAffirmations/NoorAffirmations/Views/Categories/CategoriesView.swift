//
//  CategoriesView.swift
//  NoorAffirmations
//
//  Browse affirmations by theme — soft pastel grid
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
                // Background
                Color.noorCream
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
        VStack(alignment: .leading, spacing: 8) {
            Text("Categories")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Color.noorText)

            Text("Explore affirmations by theme")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(Color.noorTextSecondary)
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
                    .fill(Color.white.opacity(0.6))
                    .frame(width: 44, height: 44)

                Image(systemName: category.icon)
                    .font(.system(size: 20, weight: .medium))
                    .foregroundStyle(Color.noorText.opacity(0.7))
            }

            VStack(alignment: .leading, spacing: 4) {
                // Title
                Text(category.rawValue)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.noorText)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)

                // Arabic subtitle
                Text(category.subtitle)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.noorTextSecondary)
            }

            // Description
            Text(category.description)
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(Color.noorTextTertiary)
                .lineLimit(2)

            Spacer(minLength: 0)

            // Quote count
            let count = QuotesData.quotes(for: category).count
            Text("\(count) affirmations")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(Color.noorTextTertiary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 200)
        .background(
            ZStack {
                LinearGradient.backgroundForCategory(category)

                // Decorative circle
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 80, height: 80)
                    .offset(x: 50, y: -20)
                    .blur(radius: 20)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: Color.noorText.opacity(0.04), radius: 12, x: 0, y: 6)
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
