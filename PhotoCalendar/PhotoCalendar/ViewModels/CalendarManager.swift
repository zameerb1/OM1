import Foundation
import SwiftUI

@MainActor
class CalendarManager: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var currentMonth: Date = Date()

    // MARK: - Navigation

    func selectDate(_ date: Date) {
        selectedDate = date
        if !date.isSameMonth(as: currentMonth) {
            currentMonth = date.startOfMonth
        }
    }

    func goToToday() {
        selectedDate = Date()
        currentMonth = Date().startOfMonth
    }

    func goToNextMonth() {
        currentMonth = currentMonth.adding(months: 1)
    }

    func goToPreviousMonth() {
        currentMonth = currentMonth.adding(months: -1)
    }

    func goToDate(_ date: Date) {
        selectedDate = date
        currentMonth = date.startOfMonth
    }

    // MARK: - Calendar Data

    var daysInCurrentMonth: [Date?] {
        let firstDay = currentMonth.startOfMonth
        let firstWeekday = firstDay.firstWeekdayOfMonth
        let numberOfDays = firstDay.numberOfDaysInMonth

        var days: [Date?] = []

        // Add empty slots for days before the first day of the month
        for _ in 1..<firstWeekday {
            days.append(nil)
        }

        // Add all days of the month
        for day in 0..<numberOfDays {
            if let date = Calendar.current.date(byAdding: .day, value: day, to: firstDay) {
                days.append(date)
            }
        }

        return days
    }

    var weekdaySymbols: [String] {
        let formatter = DateFormatter()
        return formatter.shortWeekdaySymbols
    }

    var currentMonthName: String {
        currentMonth.formattedMonthYear
    }

    var selectedDateFormatted: String {
        selectedDate.formattedDate
    }

    var selectedDayName: String {
        selectedDate.formattedDayName
    }

    // MARK: - Helpers

    func isSelected(_ date: Date) -> Bool {
        date.isSameDay(as: selectedDate)
    }

    func isToday(_ date: Date) -> Bool {
        date.isToday
    }

    func isFuture(_ date: Date) -> Bool {
        date.isFuture
    }

    func isPast(_ date: Date) -> Bool {
        date.isPast
    }
}
