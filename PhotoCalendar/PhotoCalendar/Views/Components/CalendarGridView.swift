import SwiftUI

struct CalendarGridView: View {
    @EnvironmentObject var calendarManager: CalendarManager
    @EnvironmentObject var photoManager: PhotoManager

    var onDateSelected: ((Date) -> Void)?

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 7)

    var body: some View {
        VStack(spacing: 16) {
            // Month navigation
            HStack {
                Button {
                    calendarManager.goToPreviousMonth()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .foregroundColor(.appPrimary)
                        .frame(width: 44, height: 44)
                }

                Spacer()

                Text(calendarManager.currentMonthName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.appTextPrimary)

                Spacer()

                Button {
                    calendarManager.goToNextMonth()
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.title3)
                        .foregroundColor(.appPrimary)
                        .frame(width: 44, height: 44)
                }
            }
            .padding(.horizontal)

            // Weekday headers
            HStack(spacing: 2) {
                ForEach(calendarManager.weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.appTextSecondary)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 8)

            // Calendar grid
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(Array(calendarManager.daysInCurrentMonth.enumerated()), id: \.offset) { index, date in
                    if let date = date {
                        CalendarDayCell(
                            date: date,
                            isSelected: calendarManager.isSelected(date),
                            isToday: calendarManager.isToday(date),
                            hasPhotos: photoManager.hasPhotos(onDate: date),
                            photoCount: photoManager.photoCount(forDate: date)
                        )
                        .onTapGesture {
                            calendarManager.selectDate(date)
                            onDateSelected?(date)
                        }
                    } else {
                        Color.clear
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
            .padding(.horizontal, 8)
        }
    }
}

struct CalendarDayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let hasPhotos: Bool
    let photoCount: Int

    var body: some View {
        VStack(spacing: 2) {
            Text("\(date.dayOfMonth)")
                .font(.system(size: 16, weight: isSelected || isToday ? .bold : .regular))
                .foregroundColor(foregroundColor)

            if hasPhotos {
                Circle()
                    .fill(Color.appPrimary)
                    .frame(width: 6, height: 6)
            } else {
                Circle()
                    .fill(Color.clear)
                    .frame(width: 6, height: 6)
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .background(backgroundColor)
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isToday && !isSelected ? Color.appPrimary : Color.clear, lineWidth: 2)
        )
    }

    private var foregroundColor: Color {
        if isSelected {
            return .white
        } else if date.isPast {
            return .appTextSecondary.opacity(0.5)
        } else {
            return .appTextPrimary
        }
    }

    private var backgroundColor: Color {
        if isSelected {
            return .appPrimary
        } else {
            return .clear
        }
    }
}

struct CompactCalendarView: View {
    @Binding var selectedDate: Date
    @State private var currentMonth: Date

    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        self._currentMonth = State(initialValue: selectedDate.wrappedValue.startOfMonth)
    }

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 2), count: 7)
    private let weekdaySymbols = DateFormatter().shortWeekdaySymbols!

    var body: some View {
        VStack(spacing: 12) {
            // Month navigation
            HStack {
                Button {
                    currentMonth = currentMonth.adding(months: -1)
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.appPrimary)
                }

                Spacer()

                Text(currentMonth.formattedMonthYear)
                    .font(.headline)
                    .foregroundColor(.appTextPrimary)

                Spacer()

                Button {
                    currentMonth = currentMonth.adding(months: 1)
                } label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.appPrimary)
                }
            }

            // Weekday headers
            HStack(spacing: 2) {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.caption2)
                        .foregroundColor(.appTextSecondary)
                        .frame(maxWidth: .infinity)
                }
            }

            // Calendar grid
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(Array(daysInMonth.enumerated()), id: \.offset) { index, date in
                    if let date = date {
                        Text("\(date.dayOfMonth)")
                            .font(.system(size: 14, weight: date.isSameDay(as: selectedDate) ? .bold : .regular))
                            .foregroundColor(date.isSameDay(as: selectedDate) ? .white : .appTextPrimary)
                            .frame(maxWidth: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                            .background(date.isSameDay(as: selectedDate) ? Color.appPrimary : Color.clear)
                            .cornerRadius(6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(date.isToday && !date.isSameDay(as: selectedDate) ? Color.appPrimary : Color.clear, lineWidth: 1)
                            )
                            .onTapGesture {
                                selectedDate = date
                            }
                    } else {
                        Color.clear
                            .aspectRatio(1, contentMode: .fit)
                    }
                }
            }
        }
        .padding()
        .background(Color.appCardBackground)
        .cornerRadius(16)
    }

    private var daysInMonth: [Date?] {
        let firstDay = currentMonth.startOfMonth
        let firstWeekday = firstDay.firstWeekdayOfMonth
        let numberOfDays = firstDay.numberOfDaysInMonth

        var days: [Date?] = []

        for _ in 1..<firstWeekday {
            days.append(nil)
        }

        for day in 0..<numberOfDays {
            if let date = Calendar.current.date(byAdding: .day, value: day, to: firstDay) {
                days.append(date)
            }
        }

        return days
    }
}

#Preview {
    VStack {
        CalendarGridView()
            .environmentObject(CalendarManager())
            .environmentObject(PhotoManager())

        CompactCalendarView(selectedDate: .constant(Date()))
    }
    .padding()
    .background(Color.appBackground)
}
