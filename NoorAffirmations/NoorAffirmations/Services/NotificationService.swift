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

    func scheduleDailyNotification(
        at time: Date,
        identifier: String = "dailyAffirmation",
        title: String = "Your Daily Noor",
        isMorning: Bool = true
    ) {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = isMorning
            ? getMorningAffirmationPreview()
            : getEveningAffirmationPreview()
        content.sound = .default

        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: time)

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let request = UNNotificationRequest(
            identifier: identifier,
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

    private func getMorningAffirmationPreview() -> String {
        let morningCategories: [QuoteCategory] = [.gratitude, .trustInAllah, .confidenceAndPurpose]
        let category = morningCategories.randomElement() ?? .gratitude
        let quote = QuotesData.randomQuote(from: category)
        return String(quote.text.prefix(120))
    }

    private func getEveningAffirmationPreview() -> String {
        let eveningCategories: [QuoteCategory] = [.nightReflections, .anxietyAndCalm, .healingAndHardTimes]
        let category = eveningCategories.randomElement() ?? .nightReflections
        let quote = QuotesData.randomQuote(from: category)
        return String(quote.text.prefix(120))
    }
}
