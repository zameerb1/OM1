//
//  CategoriesView.swift
//  NoorAffirmations
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
                backgroundGradient
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
            Text("Categories")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("Explore affirmations by theme")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.white.opacity(0.6))
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
                    .fill(.white.opacity(0.15))
                    .frame(width: 48, height: 48)

                Image(systemName: category.icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundStyle(.white)
            }

            // Title
            Text(category.rawValue)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
                .lineLimit(2)
                .minimumScaleFactor(0.8)

            // Description
            Text(category.description)
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(.white.opacity(0.7))
                .lineLimit(2)

            Spacer(minLength: 0)

            // Quote count
            let count = QuotesData.quotes(for: category).count
            Text("\(count) affirmations")
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 180)
        .background(
            ZStack {
                LinearGradient.forCategory(category)

                // Decorative circle
                Circle()
                    .fill(.white.opacity(0.1))
                    .frame(width: 100, height: 100)
                    .offset(x: 60, y: -30)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color(hex: category.gradientColors[0]).opacity(0.3), radius: 10, x: 0, y: 5)
        .scaleEffect(isPressed ? 0.95 : 1)
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
