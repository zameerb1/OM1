import SwiftUI

@main
struct PhotoCalendarApp: App {
    @StateObject private var photoManager = PhotoManager()
    @StateObject private var projectManager = ProjectManager()
    @StateObject private var calendarManager = CalendarManager()
    @StateObject private var settingsManager = SettingsManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(photoManager)
                .environmentObject(projectManager)
                .environmentObject(calendarManager)
                .environmentObject(settingsManager)
                .preferredColorScheme(settingsManager.isDarkMode ? .dark : .light)
        }
    }
}
