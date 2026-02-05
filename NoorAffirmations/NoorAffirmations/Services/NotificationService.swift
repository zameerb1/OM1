//
//  NotificationService.swift
//  NoorAffirmations
//

import UserNotifications

class NotificationService {
    static let shared = NotificationService()

    private init() {}

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }

    func scheduleDailyNotification(at time: Date) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "Your Daily Noor"
        content.body = getDailyAffirmationPreview()
        content.sound = .default

        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(
            identifier: "dailyAffirmation",
            content: content,
            trigger: trigger
        )

        center.add(request) { error in
            if let error = error {
                print("Failed to schedule notification: \(error)")
            }
        }
    }

    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }

    private func getDailyAffirmationPreview() -> String {
        let quote = QuotesData.dailyQuote
        let preview = String(quote.textEnglish.prefix(100))
        return preview.count < quote.textEnglish.count ? preview + "..." : preview
    }
}
