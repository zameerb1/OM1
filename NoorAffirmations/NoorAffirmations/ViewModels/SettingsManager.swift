//
//  SettingsManager.swift
//  NoorAffirmations
//

import SwiftUI

@MainActor
class SettingsManager: ObservableObject {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    @AppStorage("showArabicText") var showArabicText: Bool = true
    @AppStorage("notificationsEnabled") var notificationsEnabled: Bool = false
    @AppStorage("notificationTime") var notificationTimeData: Data = {
        // Default to 8:00 AM
        var components = DateComponents()
        components.hour = 8
        components.minute = 0
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

    func toggleNotifications() {
        notificationsEnabled.toggle()
        if notificationsEnabled {
            scheduleNotifications()
        } else {
            NotificationService.shared.cancelAllNotifications()
        }
    }

    func scheduleNotifications() {
        NotificationService.shared.scheduleDailyNotification(at: notificationTime)
    }
}
