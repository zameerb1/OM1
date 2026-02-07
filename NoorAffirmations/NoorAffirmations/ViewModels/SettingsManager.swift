//
//  SettingsManager.swift
//  NoorAffirmations
//

import SwiftUI

@MainActor
class SettingsManager: ObservableObject {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = false
    @AppStorage("reminderType") var reminderType: String = "morning"
    @AppStorage("notificationTime") var notificationTimeData: Data = {
        var components = DateComponents()
        components.hour = 7
        components.minute = 30
        let date = Calendar.current.date(from: components) ?? Date()
        return (try? JSONEncoder().encode(date)) ?? Data()
    }()

    var notificationTime: Date {
        get {
            (try? JSONDecoder().decode(Date.self, from: notificationTimeData)) ?? Date()
        }
        set {
            notificationTimeData = (try? JSONEncoder().encode(newValue)) ?? Data()
            if notificationsEnabled {
                scheduleNotifications()
            }
        }
    }

    var isMorningReminder: Bool {
        reminderType == "morning"
    }

    func setReminderType(_ type: String) {
        reminderType = type
        var components = DateComponents()
        if type == "morning" {
            components.hour = 7
            components.minute = 30
        } else {
            components.hour = 21
            components.minute = 0
        }
        if let date = Calendar.current.date(from: components) {
            notificationTime = date
        }
        if notificationsEnabled {
            scheduleNotifications()
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
        NotificationService.shared.scheduleDailyNotification(
            at: notificationTime,
            isMorning: isMorningReminder
        )
    }
}
