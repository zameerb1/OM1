//
//  ContentView.swift
//  NoorAffirmations
//
//  Main tab navigation with soft pastel custom tab bar
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab: Tab = .home
    @EnvironmentObject var settingsManager: SettingsManager

    enum Tab {
        case home, categories, favorites, settings
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case .home:
                    HomeView()
                case .categories:
                    CategoriesView()
                case .favorites:
                    FavoritesView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

            // Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: ContentView.Tab

    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(
                icon: "sparkles",
                title: "Today",
                isSelected: selectedTab == .home
            ) {
                withAnimation(.spring(response: 0.3)) {
                    selectedTab = .home
                }
            }

            TabBarButton(
                icon: "square.grid.2x2",
                title: "Categories",
                isSelected: selectedTab == .categories
            ) {
                withAnimation(.spring(response: 0.3)) {
                    selectedTab = .categories
                }
            }

            TabBarButton(
                icon: "heart.fill",
                title: "Favorites",
                isSelected: selectedTab == .favorites
            ) {
                withAnimation(.spring(response: 0.3)) {
                    selectedTab = .favorites
                }
            }

            TabBarButton(
                icon: "gearshape",
                title: "Settings",
                isSelected: selectedTab == .settings
            ) {
                withAnimation(.spring(response: 0.3)) {
                    selectedTab = .settings
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 12)
        .padding(.bottom, 28)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.noorText.opacity(0.06), radius: 20, x: 0, y: -5)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? Color.noorAccent : Color.noorTextTertiary)

                Text(title)
                    .font(.system(size: 10, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? Color.noorAccent : Color.noorTextTertiary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(isSelected ? Color.noorAccent.opacity(0.1) : .clear)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
        .environmentObject(QuoteManager())
        .environmentObject(FavoritesManager())
        .environmentObject(SettingsManager())
}
