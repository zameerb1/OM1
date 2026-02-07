//
//  QuoteCardView.swift
//  NoorAffirmations
//
//  Soft, minimal affirmation card — Glow-inspired design
//

import SwiftUI

struct QuoteCardView: View {
    let quote: Quote
    var isCompact: Bool = false

    @State private var isAppearing = false

    var body: some View {
        VStack(spacing: isCompact ? 20 : 32) {
            // Decorative top element
            if !isCompact {
                decorativeHeader
            }

            // Affirmation text
            Text(quote.text)
                .font(.system(size: isCompact ? 18 : 24, weight: .medium, design: .serif))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.noorText)
                .lineSpacing(isCompact ? 6 : 10)
                .padding(.horizontal, isCompact ? 4 : 12)

            // Inspiration reference (if present)
            if let inspiration = quote.inspiration {
                Text(inspiration)
                    .font(.system(size: isCompact ? 11 : 13, weight: .regular))
                    .foregroundStyle(Color.noorTextSecondary)
                    .multilineTextAlignment(.center)
            }

            // Category badge
            if !isCompact {
                categoryBadge
            }
        }
        .padding(isCompact ? 24 : 36)
        .frame(maxWidth: .infinity)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .shadow(color: Color.noorText.opacity(0.06), radius: 24, x: 0, y: 12)
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
            Image(systemName: quote.category.icon)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Color.noorAccent)
            decorativeLine
        }
    }

    private var decorativeLine: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [.clear, Color.noorAccentSoft, .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: 0.5)
    }

    // MARK: - Category Badge
    private var categoryBadge: some View {
        Text(quote.category.rawValue)
            .font(.system(size: 11, weight: .medium, design: .rounded))
            .foregroundStyle(Color.noorTextSecondary)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(Color.noorSoftGray)
            )
    }

    // MARK: - Card Background
    private var cardBackground: some View {
        ZStack {
            // Soft gradient base
            LinearGradient.backgroundForCategory(quote.category)

            // Subtle decorative circles
            GeometryReader { geometry in
                Circle()
                    .fill(Color.white.opacity(0.4))
                    .frame(width: 180, height: 180)
                    .offset(x: geometry.size.width * 0.35, y: -60)
                    .blur(radius: 40)

                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 120, height: 120)
                    .offset(x: -40, y: geometry.size.height * 0.6)
                    .blur(radius: 30)
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
                .font(.system(size: 14, weight: .regular, design: .serif))
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
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(LinearGradient.backgroundForCategory(quote.category))
        )
    }
}

#Preview {
    ZStack {
        Color.noorCream.ignoresSafeArea()

        QuoteCardView(
            quote: QuotesData.dailyQuote
        )
        .padding(24)
    }
}
