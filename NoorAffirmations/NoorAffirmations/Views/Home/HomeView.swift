//
//  HomeView.swift
//  NoorAffirmations
//
//  Daily affirmation home screen — calming, minimal, Glow-inspired
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var quoteManager: QuoteManager
    @EnvironmentObject var favoritesManager: FavoritesManager
    @State private var showShareSheet = false
    @State private var dragOffset: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Soft warm background
                backgroundGradient
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    headerSection
                        .padding(.top, 20)
                        .padding(.horizontal, 28)

                    Spacer()

                    // Main affirmation card
                    QuoteCardView(quote: quoteManager.currentQuote)
                        .offset(x: dragOffset)
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
                Color.noorCream,
                Color.noorWarmWhite,
                Color.noorSoftGray
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
                    Text(greeting)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.noorTextSecondary)

                    Text("Your Daily Noor")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundStyle(Color.noorText)
                }

                Spacer()

                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 28))
                    .foregroundStyle(Color.noorAccent)
            }

            Text(formattedDate)
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(Color.noorTextTertiary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        if hour < 12 {
            return "Bismillah, good morning"
        } else if hour < 17 {
            return "Bismillah, good afternoon"
        } else {
            return "Bismillah, good evening"
        }
    }

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        return formatter.string(from: Date())
    }

    // MARK: - Action Buttons
    private var actionButtons: some View {
        HStack(spacing: 36) {
            // Previous
            SoftCircleButton(icon: "chevron.left") {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    quoteManager.previousQuote()
                }
            }

            // Favorite
            SoftCircleButton(
                icon: favoritesManager.isFavorite(quoteManager.currentQuote) ? "heart.fill" : "heart",
                isAccent: favoritesManager.isFavorite(quoteManager.currentQuote)
            ) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    favoritesManager.toggleFavorite(quoteManager.currentQuote)
                }
            }

            // Share
            SoftCircleButton(icon: "square.and.arrow.up") {
                showShareSheet = true
            }

            // Next
            SoftCircleButton(icon: "chevron.right") {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
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
                dragOffset = value.translation.width * 0.6
            }
            .onEnded { value in
                let threshold: CGFloat = 80
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    if value.translation.width > threshold {
                        quoteManager.previousQuote()
                    } else if value.translation.width < -threshold {
                        quoteManager.nextQuote()
                    }
                    dragOffset = 0
                }
            }
    }

    // MARK: - Helpers
    private func formatQuoteForSharing(_ quote: Quote) -> String {
        var text = "\"\(quote.text)\"\n\n"
        if let inspiration = quote.inspiration {
            text += "\(inspiration)\n\n"
        }
        text += "— Noor Affirmations"
        return text
    }
}

// MARK: - Soft Circle Button
struct SoftCircleButton: View {
    let icon: String
    var isAccent: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(isAccent ? Color.noorAccent : Color.noorText)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(Color.white)
                        .shadow(color: Color.noorText.opacity(0.06), radius: 8, x: 0, y: 4)
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
}
