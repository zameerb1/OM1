//
//  QuoteCardView.swift
//  NoorAffirmations
//
//  Soft, calming affirmation card inspired by Glow app aesthetic
//

import SwiftUI

struct QuoteCardView: View {
    let quote: Quote
    var isCompact: Bool = false

    @State private var isAppearing = false

    var body: some View {
        VStack(spacing: isCompact ? 20 : 32) {
            if !isCompact {
                decorativeHeader
            }

            // Affirmation text
            Text(quote.text)
                .font(.system(size: isCompact ? 18 : 24, weight: .medium, design: .serif))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.noorTextPrimary)
                .lineSpacing(isCompact ? 6 : 10)
                .padding(.horizontal, isCompact ? 8 : 16)

            // Optional inspiration (Qur'anic/prophetic reference)
            if let inspiration = quote.inspiration {
                Text(inspiration)
                    .font(.system(size: isCompact ? 12 : 14, weight: .regular, design: .serif))
                    .italic()
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.noorTextSecondary)
                    .padding(.horizontal, 16)
            }

            if !isCompact {
                categoryBadge
            }
        }
        .padding(isCompact ? 24 : 36)
        .frame(maxWidth: .infinity)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 20, x: 0, y: 8)
        .opacity(isAppearing ? 1 : 0)
        .scaleEffect(isAppearing ? 1 : 0.96)
        .onAppear {
            withAnimation(.easeOut(duration: 0.5)) {
                isAppearing = true
            }
        }
        .onChange(of: quote.id) { _, _ in
            isAppearing = false
            withAnimation(.easeOut(duration: 0.4)) {
                isAppearing = true
            }
        }
    }

    // MARK: - Decorative Header
    private var decorativeHeader: some View {
        HStack(spacing: 12) {
            decorativeLine
            Image(systemName: "sparkle")
                .font(.system(size: 8))
                .foregroundStyle(Color.noorAccentWarm)
            decorativeLine
        }
        .padding(.bottom, 4)
    }

    private var decorativeLine: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [.clear, Color.noorAccentWarm.opacity(0.4), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: 0.5)
    }

    // MARK: - Category Badge
    private var categoryBadge: some View {
        HStack(spacing: 6) {
            Image(systemName: quote.category.icon)
                .font(.system(size: 10))
            Text(quote.category.rawValue)
                .font(.system(size: 11, weight: .medium))
        }
        .foregroundStyle(Color.noorTextTertiary)
        .padding(.horizontal, 14)
        .padding(.vertical, 7)
        .background(
            Capsule()
                .fill(Color.noorSurface)
        )
    }

    // MARK: - Card Background
    private var cardBackground: some View {
        ZStack {
            // Soft pastel gradient based on category
            LinearGradient.forCategory(quote.category)
                .opacity(0.35)

            // Subtle warm overlay
            Color.noorCardBackground.opacity(0.7)

            // Soft decorative circles
            GeometryReader { geometry in
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 180, height: 180)
                        .offset(x: geometry.size.width * 0.35, y: -80)

                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 120, height: 120)
                        .offset(x: -geometry.size.width * 0.3, y: geometry.size.height * 0.5)
                }
            }
            .clipped()
        }
    }
}

// MARK: - Mini Quote Card (for lists)
struct MiniQuoteCard: View {
    let quote: Quote

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
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
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color.noorCardBackground)
                .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    ZStack {
        Color.noorBackground.ignoresSafeArea()

        QuoteCardView(
            quote: QuotesData.dailyQuote
        )
        .padding(24)
    }
}
