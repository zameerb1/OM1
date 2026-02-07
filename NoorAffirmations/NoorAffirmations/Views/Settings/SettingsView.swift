//
//  SettingsView.swift
//  NoorAffirmations
//
//  Soft, minimal settings with morning/evening reminder controls
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var showMorningTimePicker = false
    @State private var showEveningTimePicker = false

    var body: some View {
        ZStack {
            Color.noorBackground
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    headerSection
                        .padding(.horizontal, 24)
                        .padding(.top, 16)

                    // Settings sections
                    VStack(spacing: 20) {
                        // Reminders
                        settingsSection(title: "Reminders") {
                            SettingsToggleRow(
                                icon: "bell",
                                title: "Daily Reminders",
                                subtitle: "Gentle affirmation notifications",
                                isOn: Binding(
                                    get: { settingsManager.notificationsEnabled },
                                    set: { _ in settingsManager.toggleNotifications() }
                                )
                            )

                            if settingsManager.notificationsEnabled {
                                // Reminder time preference
                                VStack(spacing: 0) {
                                    ForEach(ReminderTime.allCases, id: \.rawValue) { option in
                                        ReminderOptionRow(
                                            option: option,
                                            isSelected: settingsManager.reminderTimePreference == option
                                        ) {
                                            settingsManager.reminderTimePreference = option
                                        }
                                    }
                                }

                                // Time pickers
                                if settingsManager.reminderTimePreference == .morning || settingsManager.reminderTimePreference == .both {
                                    SettingsActionRow(
                                        icon: "sunrise",
                                        title: "Morning Time",
                                        value: formattedTime(settingsManager.morningTime)
                                    ) {
                                        showMorningTimePicker = true
                                    }
                                }

                                if settingsManager.reminderTimePreference == .evening || settingsManager.reminderTimePreference == .both {
                                    SettingsActionRow(
                                        icon: "moon",
                                        title: "Evening Time",
                                        value: formattedTime(settingsManager.eveningTime)
                                    ) {
                                        showEveningTimePicker = true
                                    }
                                }
                            }
                        }

                        // About Section
                        settingsSection(title: "About") {
                            SettingsInfoRow(
                                icon: "info.circle",
                                title: "Version",
                                value: "1.0.0"
                            )

                            SettingsInfoRow(
                                icon: "text.quote",
                                title: "Total Affirmations",
                                value: "\(QuotesData.allQuotes.count)"
                            )

                            SettingsInfoRow(
                                icon: "square.grid.2x2",
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
        .sheet(isPresented: $showMorningTimePicker) {
            TimePickerSheet(
                title: "Morning Reminder",
                selectedTime: Binding(
                    get: { settingsManager.morningTime },
                    set: { settingsManager.morningTime = $0 }
                )
            )
            .presentationDetents([.height(320)])
        }
        .sheet(isPresented: $showEveningTimePicker) {
            TimePickerSheet(
                title: "Evening Reminder",
                selectedTime: Binding(
                    get: { settingsManager.eveningTime },
                    set: { settingsManager.eveningTime = $0 }
                )
            )
            .presentationDetents([.height(320)])
        }
    }

    // MARK: - Header
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Settings")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Color.noorTextPrimary)

            Text("Customize your experience")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(Color.noorTextTertiary)
        }
    }

    // MARK: - Settings Section
    private func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title.uppercased())
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.noorTextTertiary)
                .padding(.leading, 4)

            VStack(spacing: 0) {
                content()
            }
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.noorCardBackground)
                    .shadow(color: .black.opacity(0.04), radius: 8, x: 0, y: 3)
            )
        }
    }

    // MARK: - App Info
    private var appInfoSection: some View {
        VStack(spacing: 14) {
            // App icon
            ZStack {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [Color.noorPeach, Color.noorSand],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 72, height: 72)

                Image(systemName: "moon.stars")
                    .font(.system(size: 30, weight: .light))
                    .foregroundStyle(Color.noorTextPrimary.opacity(0.7))
            }

            VStack(spacing: 4) {
                Text("Noor")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.noorTextPrimary)

                Text("Islamic Affirmations")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Color.noorTextTertiary)
            }

            Text("May these words bring light to your heart\nand peace to your soul.")
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(Color.noorTextTertiary)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 28)
    }

    private func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Reminder Option Row
struct ReminderOptionRow: View {
    let option: ReminderTime
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 18))
                    .foregroundStyle(isSelected ? Color.noorAccentWarm : Color.noorTextTertiary)

                VStack(alignment: .leading, spacing: 2) {
                    Text(option.rawValue)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(Color.noorTextPrimary)

                    Text(option.description)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(Color.noorTextTertiary)
                }

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .buttonStyle(.plain)
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
                .font(.system(size: 16))
                .foregroundStyle(Color.noorAccentWarm)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.noorTextPrimary)

                Text(subtitle)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color.noorTextTertiary)
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .tint(Color.noorAccentWarm)
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
                    .font(.system(size: 16))
                    .foregroundStyle(Color.noorAccentWarm)
                    .frame(width: 28)

                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.noorTextPrimary)

                Spacer()

                Text(value)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color.noorTextTertiary)

                Image(systemName: "chevron.right")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color.noorTextTertiary.opacity(0.5))
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
                .font(.system(size: 16))
                .foregroundStyle(Color.noorAccentWarm)
                .frame(width: 28)

            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.noorTextPrimary)

            Spacer()

            Text(value)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.noorTextTertiary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

// MARK: - Time Picker Sheet
struct TimePickerSheet: View {
    var title: String = "Reminder Time"
    @Binding var selectedTime: Date
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text(title)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
                    .foregroundStyle(Color.noorTextPrimary)

                Spacer()

                Button("Done") {
                    dismiss()
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.noorAccentWarm)
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
        .background(Color.noorBackground)
    }
}

#Preview {
    SettingsView()
        .environmentObject(SettingsManager())
}
