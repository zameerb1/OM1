//
//  SettingsView.swift
//  NoorAffirmations
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var showTimePicker = false

    var body: some View {
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

                    // Settings sections
                    VStack(spacing: 20) {
                        // Display Settings
                        settingsSection(title: "Display") {
                            SettingsToggleRow(
                                icon: "moon.fill",
                                title: "Dark Mode",
                                subtitle: "Use dark appearance",
                                isOn: $settingsManager.isDarkMode
                            )

                            SettingsToggleRow(
                                icon: "character.book.closed.ar",
                                title: "Show Arabic Text",
                                subtitle: "Display original Arabic verses",
                                isOn: $settingsManager.showArabicText
                            )
                        }

                        // Notifications Settings
                        settingsSection(title: "Notifications") {
                            SettingsToggleRow(
                                icon: "bell.fill",
                                title: "Daily Reminder",
                                subtitle: "Get your daily affirmation",
                                isOn: Binding(
                                    get: { settingsManager.notificationsEnabled },
                                    set: { _ in settingsManager.toggleNotifications() }
                                )
                            )

                            if settingsManager.notificationsEnabled {
                                SettingsActionRow(
                                    icon: "clock.fill",
                                    title: "Reminder Time",
                                    value: formattedTime
                                ) {
                                    showTimePicker = true
                                }
                            }
                        }

                        // About Section
                        settingsSection(title: "About") {
                            SettingsInfoRow(
                                icon: "info.circle.fill",
                                title: "Version",
                                value: "1.0.0"
                            )

                            SettingsInfoRow(
                                icon: "book.fill",
                                title: "Total Affirmations",
                                value: "\(QuotesData.allQuotes.count)"
                            )

                            SettingsInfoRow(
                                icon: "square.grid.2x2.fill",
                                title: "Categories",
                                value: "\(QuoteCategory.allCases.count)"
                            )
                        }

                        // App Info
                        appInfoSection
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 140)
                }
            }
        }
        .sheet(isPresented: $showTimePicker) {
            TimePickerSheet(
                selectedTime: Binding(
                    get: { settingsManager.notificationTime },
                    set: { settingsManager.notificationTime = $0 }
                )
            )
            .presentationDetents([.height(320)])
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
            Text("Settings")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("Customize your experience")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(.white.opacity(0.6))
        }
    }

    // MARK: - Settings Section
    private func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title.uppercased())
                .font(.system(size: 12, weight: .semibold))
                .foregroundStyle(.white.opacity(0.5))
                .padding(.leading, 4)

            VStack(spacing: 0) {
                content()
            }
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.white.opacity(0.05))
            )
        }
    }

    // MARK: - App Info
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            // App icon
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(LinearGradient.islamicGold)
                    .frame(width: 80, height: 80)

                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(.white)
            }

            VStack(spacing: 4) {
                Text("Noor Affirmations")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)

                Text("Islamic Daily Affirmations")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(.white.opacity(0.6))
            }

            Text("May these words of wisdom bring light to your heart and strengthen your faith.")
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(.white.opacity(0.5))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
    }

    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: settingsManager.notificationTime)
    }
}

// MARK: - Settings Row Components
struct SettingsToggleRow: View {
    let icon: String
    let title: String
    let subtitle: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(Color.accentGold)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white)

                Text(subtitle)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.white.opacity(0.5))
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .tint(Color.accentGold)
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

struct SettingsActionRow: View {
    let icon: String
    let title: String
    let value: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(Color.accentGold)
                    .frame(width: 32)

                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.white)

                Spacer()

                Text(value)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.white.opacity(0.6))

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.3))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .buttonStyle(.plain)
    }
}

struct SettingsInfoRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundStyle(Color.accentGold)
                .frame(width: 32)

            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white)

            Spacer()

            Text(value)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(.white.opacity(0.6))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

// MARK: - Time Picker Sheet
struct TimePickerSheet: View {
    @Binding var selectedTime: Date
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 24) {
            // Header
            HStack {
                Text("Reminder Time")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.primary)

                Spacer()

                Button("Done") {
                    dismiss()
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.accentGold)
            }
            .padding(.horizontal, 24)
            .padding(.top, 20)

            DatePicker(
                "",
                selection: $selectedTime,
                displayedComponents: .hourAndMinute
            )
            .datePickerStyle(.wheel)
            .labelsHidden()

            Spacer()
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsManager())
}
