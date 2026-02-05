//
//  HomeView.swift
//  NoorAffirmations
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var quoteManager: QuoteManager
    @EnvironmentObject var favoritesManager: FavoritesManager
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var showShareSheet = false
    @State private var dragOffset: CGFloat = 0
    @State private var cardRotation: Double = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background gradient
                backgroundGradient
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    headerSection
                        .padding(.top, 16)
                        .padding(.horizontal, 24)

                    Spacer()

                    // Main quote card
                    QuoteCardView(
                        quote: quoteManager.currentQuote,
                        showArabic: settingsManager.showArabicText
                    )
                    .offset(x: dragOffset)
                    .rotation3DEffect(
                        .degrees(cardRotation),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .gesture(swipeGesture)
                    .padding(.horizontal, 24)

                    Spacer()

                    // Action buttons
                    actionButtons
                        .padding(.horizontal, 40)
                        .padding(.bottom, 120)
                }
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
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Bismillah")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white.opacity(0.7))

                    Text("Your Daily Noor")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }

                Spacer()

                // Decorative crescent moon
                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(
                        LinearGradient.islamicGold
                    )
            }

            // Date
            Text(formattedDate)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.white.opacity(0.5))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter.string(from: Date())
    }

    // MARK: - Action Buttons
    private var actionButtons: some View {
        HStack(spacing: 40) {
            // Previous button
            CircleButton(icon: "chevron.left") {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    quoteManager.previousQuote()
                }
            }

            // Favorite button
            CircleButton(
                icon: favoritesManager.isFavorite(quoteManager.currentQuote) ? "heart.fill" : "heart",
                isAccent: favoritesManager.isFavorite(quoteManager.currentQuote)
            ) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    favoritesManager.toggleFavorite(quoteManager.currentQuote)
                }
            }

            // Share button
            CircleButton(icon: "square.and.arrow.up") {
                showShareSheet = true
            }

            // Next button
            CircleButton(icon: "chevron.right") {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    quoteManager.nextQuote()
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheet(items: [formatQuoteForSharing(quoteManager.currentQuote)])
        }
    }

    // MARK: - Gestures
    private var swipeGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation.width
                cardRotation = Double(value.translation.width / 20)
            }
            .onEnded { value in
                let threshold: CGFloat = 100
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    if value.translation.width > threshold {
                        quoteManager.previousQuote()
                    } else if value.translation.width < -threshold {
                        quoteManager.nextQuote()
                    }
                    dragOffset = 0
                    cardRotation = 0
                }
            }
    }

    // MARK: - Helpers
    private func formatQuoteForSharing(_ quote: Quote) -> String {
        var text = "\"\(quote.textEnglish)\"\n\n"
        if let arabic = quote.textArabic {
            text += "\(arabic)\n\n"
        }
        text += "— \(quote.source)"
        if let reference = quote.reference {
            text += " (\(reference))"
        }
        text += "\n\nShared from Noor Affirmations"
        return text
    }
}

// MARK: - Circle Button
struct CircleButton: View {
    let icon: String
    var isAccent: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(isAccent ? Color.accentGold : .white)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(.ultraThinMaterial)
                )
                .overlay(
                    Circle()
                        .strokeBorder(
                            isAccent ? Color.accentGold.opacity(0.5) : .white.opacity(0.2),
                            lineWidth: 1
                        )
                )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

#Preview {
    HomeView()
        .environmentObject(QuoteManager())
        .environmentObject(FavoritesManager())
        .environmentObject(SettingsManager())
}
