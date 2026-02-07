//
//  SettingsManager.swift
//  NoorAffirmations
//

import SwiftUI

enum ReminderTime: String, CaseIterable {
    case morning = "Morning"
    case evening = "Evening"
    case both = "Both"

    var description: String {
        switch self {
        case .morning: return "Start your day with light"
        case .evening: return "End your day with peace"
        case .both: return "Morning & evening reminders"
        }
    }
}

@MainActor
class SettingsManager: ObservableObject {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = false
    @AppStorage("reminderTimePreference") var reminderTimePreferenceRaw: String = ReminderTime.morning.rawValue

    @AppStorage("morningNotificationTime") var morningTimeData: Data = {
        var components = DateComponents()
        components.hour = 7
        components.minute = 30
        let date = Calendar.current.date(from: components) ?? Date()
        return (try? JSONEncoder().encode(date)) ?? Data()
    }()

    @AppStorage("eveningNotificationTime") var eveningTimeData: Data = {
        var components = DateComponents()
        components.hour = 21
        components.minute = 0
        let date = Calendar.current.date(from: components) ?? Date()
        return (try? JSONEncoder().encode(date)) ?? Data()
    }()

    var reminderTimePreference: ReminderTime {
        get { ReminderTime(rawValue: reminderTimePreferenceRaw) ?? .morning }
        set {
            reminderTimePreferenceRaw = newValue.rawValue
            if notificationsEnabled {
                scheduleNotifications()
            }
        }
    }

    var morningTime: Date {
        get {
            (try? JSONDecoder().decode(Date.self, from: morningTimeData)) ?? Date()
        }
        set {
            morningTimeData = (try? JSONEncoder().encode(newValue)) ?? Data()
            if notificationsEnabled {
                scheduleNotifications()
            }
        }
    }

    var eveningTime: Date {
        get {
            (try? JSONDecoder().decode(Date.self, from: eveningTimeData)) ?? Date()
        }
        set {
            eveningTimeData = (try? JSONEncoder().encode(newValue)) ?? Data()
            if notificationsEnabled {
                scheduleNotifications()
            }
        }
    }

    func toggleNotifications() {
        notificationsEnabled.toggle()
        if notificationsEnabled {
            scheduleNotifications()
        } else {
            NotificationService.shared.cancelAllNotifications()
        }
    }

    func scheduleNotifications() {
        NotificationService.shared.cancelAllNotifications()

        switch reminderTimePreference {
        case .morning:
            NotificationService.shared.scheduleDailyNotification(
                at: morningTime,
                identifier: "morningAffirmation",
                title: "Your Morning Noor",
                isMorning: true
            )
        case .evening:
            NotificationService.shared.scheduleDailyNotification(
                at: eveningTime,
                identifier: "eveningAffirmation",
                title: "Your Evening Reflection",
                isMorning: false
            )
        case .both:
            NotificationService.shared.scheduleDailyNotification(
                at: morningTime,
                identifier: "morningAffirmation",
                title: "Your Morning Noor",
                isMorning: true
            )
            NotificationService.shared.scheduleDailyNotification(
                at: eveningTime,
                identifier: "eveningAffirmation",
                title: "Your Evening Reflection",
                isMorning: false
            )
        }
    }
}
