import Foundation

struct Project: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var color: ProjectColor
    var startDate: Date?
    var endDate: Date?
    var notes: String
    var createdAt: Date
    var photoIds: [UUID]

    init(
        id: UUID = UUID(),
        name: String,
        color: ProjectColor = .blue,
        startDate: Date? = nil,
        endDate: Date? = nil,
        notes: String = "",
        createdAt: Date = Date(),
        photoIds: [UUID] = []
    ) {
        self.id = id
        self.name = name
        self.color = color
        self.startDate = startDate
        self.endDate = endDate
        self.notes = notes
        self.createdAt = createdAt
        self.photoIds = photoIds
    }
}

enum ProjectColor: String, Codable, CaseIterable {
    case blue
    case green
    case orange
    case red
    case purple
    case teal
    case pink
    case yellow

    var colorName: String {
        switch self {
        case .blue: return "Blue"
        case .green: return "Green"
        case .orange: return "Orange"
        case .red: return "Red"
        case .purple: return "Purple"
        case .teal: return "Teal"
        case .pink: return "Pink"
        case .yellow: return "Yellow"
        }
    }

    var icon: String {
        "folder.fill"
    }
}
