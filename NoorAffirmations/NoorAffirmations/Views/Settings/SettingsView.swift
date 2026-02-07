//
//  SettingsView.swift
//  NoorAffirmations
//
//  Settings with morning/evening reminder options
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var settingsManager: SettingsManager
    @State private var showTimePicker = false

    var body: some View {
        ZStack {
            Color.noorCream
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    headerSection
                        .padding(.horizontal, 24)
                        .padding(.top, 16)

                    VStack(spacing: 20) {
                        // Notifications Settings
                        settingsSection(title: "Reminders") {
                            SettingsToggleRow(
                                icon: "bell.fill",
                                title: "Daily Reminder",
                                subtitle: "Receive a gentle nudge each day",
                                isOn: Binding(
                                    get: { settingsManager.notificationsEnabled },
                                    set: { _ in settingsManager.toggleNotifications() }
                                )
                            )

                            if settingsManager.notificationsEnabled {
                                Divider()
                                    .padding(.horizontal, 16)

                                // Morning / Evening picker
                                reminderTypePicker

                                Divider()
                                    .padding(.horizontal, 16)

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

                            Divider()
                                .padding(.horizontal, 16)

                            SettingsInfoRow(
                                icon: "text.quote",
                                title: "Total Affirmations",
                                value: "\(QuotesData.allQuotes.count)"
                            )

                            Divider()
                                .padding(.horizontal, 16)

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

    // MARK: - Header
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Settings")
                .font(.system(size: 32, weight: .bold, design: .rounded))
                .foregroundStyle(Color.noorText)

            Text("Customize your experience")
                .font(.system(size: 15, weight: .regular))
                .foregroundStyle(Color.noorTextSecondary)
        }
    }

    // MARK: - Reminder Type Picker
    private var reminderTypePicker: some View {
        HStack(spacing: 12) {
            Image(systemName: settingsManager.isMorningReminder ? "sunrise.fill" : "moon.fill")
                .font(.system(size: 18))
                .foregroundStyle(Color.noorAccent)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text("When")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.noorText)

                Text(settingsManager.isMorningReminder ? "Start your day with light" : "End your day with peace")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color.noorTextTertiary)
            }

            Spacer()

            Picker("", selection: Binding(
                get: { settingsManager.reminderType },
                set: { settingsManager.setReminderType($0) }
            )) {
                Text("Morning").tag("morning")
                Text("Evening").tag("evening")
            }
            .pickerStyle(.segmented)
            .frame(width: 160)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }

    // MARK: - Settings Section
    private func settingsSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title.uppercased())
                .font(.system(size: 12, weight: .semibold, design: .rounded))
                .foregroundStyle(Color.noorTextTertiary)
                .padding(.leading, 4)

            VStack(spacing: 0) {
                content()
            }
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.white)
                    .shadow(color: Color.noorText.opacity(0.04), radius: 8, x: 0, y: 4)
            )
        }
    }

    // MARK: - App Info
    private var appInfoSection: some View {
        VStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(LinearGradient.noorDefault)
                    .frame(width: 72, height: 72)

                Image(systemName: "moon.stars.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(Color.noorAccent)
            }

            VStack(spacing: 4) {
                Text("Noor")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.noorText)

                Text("Islamic Daily Affirmations")
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Color.noorTextSecondary)
            }

            Text("May these words bring light to your heart\nand softness to your day.")
                .font(.system(size: 12, weight: .regular))
                .foregroundStyle(Color.noorTextTertiary)
                .multilineTextAlignment(.center)
                .lineSpacing(4)
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
                .foregroundStyle(Color.noorAccent)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.noorText)

                Text(subtitle)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color.noorTextTertiary)
            }

            Spacer()

            Toggle("", isOn: $isOn)
                .tint(Color.noorAccent)
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
                    .foregroundStyle(Color.noorAccent)
                    .frame(width: 32)

                Text(title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color.noorText)

                Spacer()

                Text(value)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(Color.noorTextSecondary)

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.noorTextTertiary)
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
                .foregroundStyle(Color.noorAccent)
                .frame(width: 32)

            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.noorText)

            Spacer()

            Text(value)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(Color.noorTextSecondary)
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
            HStack {
                Text("Reminder Time")
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .foregroundStyle(Color.noorText)

                Spacer()

                Button("Done") {
                    dismiss()
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.noorAccent)
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
