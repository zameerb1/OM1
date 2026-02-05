import Foundation
import SwiftUI

@MainActor
class SettingsManager: ObservableObject {
    @AppStorage("autoSaveToPhotos") var autoSaveToPhotos: Bool = false
    @AppStorage("defaultProjectId") var defaultProjectIdString: String = ""
    @AppStorage("showPastDates") var showPastDates: Bool = true
    @AppStorage("defaultToFutureDate") var defaultToFutureDate: Bool = true
    @AppStorage("gridViewColumns") var gridViewColumns: Int = 3
    @AppStorage("isDarkMode") var isDarkMode: Bool = false

    var defaultProjectId: UUID? {
        get {
            guard !defaultProjectIdString.isEmpty else { return nil }
            return UUID(uuidString: defaultProjectIdString)
        }
        set {
            defaultProjectIdString = newValue?.uuidString ?? ""
        }
    }

    func resetSettings() {
        autoSaveToPhotos = false
        defaultProjectIdString = ""
        showPastDates = true
        defaultToFutureDate = true
        gridViewColumns = 3
        isDarkMode = false
    }
}
