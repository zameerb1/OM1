//
//  QuoteCardView.swift
//  NoorAffirmations
//

import SwiftUI

struct QuoteCardView: View {
    let quote: Quote
    var showArabic: Bool = true
    var isCompact: Bool = false

    @State private var isAppearing = false

    var body: some View {
        VStack(spacing: isCompact ? 16 : 24) {
            // Decorative Islamic pattern
            if !isCompact {
                decorativeHeader
            }

            // Arabic text (if available)
            if showArabic, let arabic = quote.textArabic {
                Text(arabic)
                    .font(.system(size: isCompact ? 18 : 22, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white.opacity(0.9))
                    .lineSpacing(8)
                    .padding(.horizontal, 8)
            }

            // English text
            Text(quote.textEnglish)
                .font(.system(size: isCompact ? 16 : 20, weight: .regular, design: .serif))
                .multilineTextAlignment(.center)
                .foregroundStyle(.white)
                .lineSpacing(6)
                .padding(.horizontal, 8)

            // Source and reference
            VStack(spacing: 4) {
                Text("— \(quote.source)")
                    .font(.system(size: isCompact ? 12 : 14, weight: .semibold))
                    .foregroundStyle(Color.accentGold)

                if let reference = quote.reference {
                    Text(reference)
                        .font(.system(size: isCompact ? 10 : 12, weight: .regular))
                        .foregroundStyle(.white.opacity(0.6))
                }
            }
            .padding(.top, 8)

            // Category badge
            if !isCompact {
                categoryBadge
            }
        }
        .padding(isCompact ? 20 : 32)
        .frame(maxWidth: .infinity)
        .background(cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
        .opacity(isAppearing ? 1 : 0)
        .scaleEffect(isAppearing ? 1 : 0.95)
        .onAppear {
            withAnimation(.easeOut(duration: 0.4)) {
                isAppearing = true
            }
        }
        .onChange(of: quote.id) { _, _ in
            isAppearing = false
            withAnimation(.easeOut(duration: 0.3)) {
                isAppearing = true
            }
        }
    }

    // MARK: - Decorative Header
    private var decorativeHeader: some View {
        HStack(spacing: 8) {
            decorativeLine
            Image(systemName: "star.fill")
                .font(.system(size: 10))
                .foregroundStyle(Color.accentGold)
            decorativeLine
        }
        .padding(.bottom, 8)
    }

    private var decorativeLine: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [.clear, Color.accentGold.opacity(0.5), .clear],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .frame(height: 1)
    }

    // MARK: - Category Badge
    private var categoryBadge: some View {
        HStack(spacing: 6) {
            Image(systemName: quote.category.icon)
                .font(.system(size: 10))
            Text(quote.category.rawValue)
                .font(.system(size: 11, weight: .medium))
        }
        .foregroundStyle(.white.opacity(0.7))
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(.white.opacity(0.1))
        )
    }

    // MARK: - Card Background
    private var cardBackground: some View {
        ZStack {
            // Base gradient
            LinearGradient.forCategory(quote.category)
                .opacity(0.9)

            // Overlay pattern
            GeometryReader { geometry in
                ZStack {
                    // Top-right decorative element
                    Circle()
                        .fill(.white.opacity(0.05))
                        .frame(width: 200, height: 200)
                        .offset(x: geometry.size.width * 0.4, y: -100)

                    // Bottom-left decorative element
                    Circle()
                        .fill(.white.opacity(0.03))
                        .frame(width: 150, height: 150)
                        .offset(x: -geometry.size.width * 0.3, y: geometry.size.height * 0.6)
                }
            }
            .clipped()

            // Glass effect overlay
            Rectangle()
                .fill(.ultraThinMaterial.opacity(0.1))
        }
    }
}

// MARK: - Mini Quote Card (for lists)
struct MiniQuoteCard: View {
    let quote: Quote

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Quote text preview
            Text(quote.textEnglish)
                .font(.system(size: 14, weight: .regular, design: .serif))
                .foregroundStyle(.white)
                .lineLimit(3)
                .lineSpacing(4)

            HStack {
                // Source
                Text(quote.source)
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color.accentGold)

                Spacer()

                // Category icon
                Image(systemName: quote.category.icon)
                    .font(.system(size: 12))
                    .foregroundStyle(.white.opacity(0.6))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(
                    LinearGradient.forCategory(quote.category)
                        .opacity(0.8)
                )
        )
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()

        QuoteCardView(
            quote: QuotesData.dailyQuote,
            showArabic: true
        )
        .padding(24)
    }
}
